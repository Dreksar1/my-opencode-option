import { readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

function authJsonPath(): string {
  if (process.env.OPENCODE_AUTH) return process.env.OPENCODE_AUTH;
  return join(homedir(), ".local", "share", "opencode", "auth.json");
}

export function getApiKey(workspace: string): string | null {
  // 1st priority: /connect credentials stored in auth.json (deepseek.key)
  try {
    const auth = JSON.parse(readFileSync(authJsonPath(), "utf-8"));
    const key = auth?.deepseek?.key;
    if (typeof key === "string" && key.length > 0) return key;
  } catch {
    // auth.json missing / unparsable / no deepseek entry → fall through
  }

  // 2nd priority: env var (fallback)
  const envKey = process.env.DEEPSEEK_API_KEY;
  if (envKey) return envKey;

  try {
    const configPath = `${workspace}/opencode.json`;
    const config = JSON.parse(readFileSync(configPath, "utf-8"));
    const dsConfig = config?.provider?.deepseek;
    if (!dsConfig) return null;
    const rawKey = dsConfig.options?.apiKey || "";
    if (rawKey.startsWith("{env:") && rawKey.endsWith("}")) {
      const envVar = rawKey.slice(5, -1);
      return process.env[envVar] || null;
    }
    return rawKey;
  } catch {
    return null;
  }
}

export async function fetchBalance(apiKey: string): Promise<{
  total: number;
  currency: string;
} | null> {
  try {
    const ctrl = new AbortController();
    const t = setTimeout(() => ctrl.abort(), 15_000);
    const resp = await fetch("https://api.deepseek.com/user/balance", {
      headers: { Authorization: `Bearer ${apiKey}` },
      signal: ctrl.signal,
    });
    clearTimeout(t);
    if (!resp.ok) {
      console.error(`[deepseek-balance] API 返回 ${resp.status}`);
      return null;
    }
    const data = (await resp.json()) as {
      is_available: boolean;
      balance_infos: Array<{ currency: string; total_balance: string }>;
    };
    if (!data.is_available || !data.balance_infos?.length) {
      if (data.is_available)
        console.error("[deepseek-balance] balance_infos 为空");
      return null;
    }
    const info = data.balance_infos[0];
    return {
      total: parseFloat(info.total_balance),
      currency: info.currency,
    };
  } catch (err) {
    if ((err as Error).name === "AbortError") {
      console.error("[deepseek-balance] 查询超时");
    } else {
      console.error("[deepseek-balance] 查询余额失败:", err);
    }
    return null;
  }
}
