/** @jsxImportSource @opentui/solid */
import { createSignal, createEffect, onCleanup } from "solid-js";
import { getApiKey, fetchBalance } from "./api";

export const tui = (api: any) => {
  const [balance, setBalance] = createSignal<string | null>(null);

  const key = getApiKey(process.cwd()) || process.env.DEEPSEEK_API_KEY || null;

  const poll = () => {
    if (!key) return;
    fetchBalance(key).then((b) => {
      if (b) setBalance(`${b.total.toFixed(2)} ${b.currency}`);
    });
  };

  poll(); // initial fetch

  api.slots.register({
    slots: {
      sidebar_content(_ctx: any) {
        // Register hook via createEffect (cache-hit pattern)
        createEffect(() => {
          const unsub = api.event?.on?.("message.updated", poll);
          onCleanup(() => unsub?.());
        });

        return (
          <box border paddingX={1} paddingY={0} width="100%">
            <text>💰 DeepSeek 剩余{balance() ? ` ${balance()}` : ""}</text>
          </box>
        );
      },
    },
  });
};

export default { id: "deepseek-balance", tui };
