# Consolidate the completion stack around `blink.cmp`

## Context
Your config is already using `blink.cmp` as the active completion engine:
- `lua/plugins/blink-cmp.lua` defines the active completion setup
- `blink.cmp` uses the built-in `snippets` source and can use Neovim's native `vim.snippet` API by default
- `friendly-snippets` is already installed

However, the config still carries older completion leftovers:
- `lua/plugins/lsp/lsp.lua` still depends on:
  - `L3MON4D3/LuaSnip`
  - `saadparwaiz1/cmp_luasnip`
- `lua/plugins/lazydev.lua` still declares an `hrsh7th/nvim-cmp` integration block
- `lazy-lock.json` still contains `nvim-cmp`, `LuaSnip`, and `cmp_luasnip`

Based on current `blink.cmp` docs, Blink can use:
- native `vim.snippet` by default
- `friendly-snippets` for snippet content
- an explicit `lazydev.integrations.blink` provider for Lua `require()`/module completions

## Important dependency between checklist items
The checklist currently separates:
1. Remove leftover `nvim-cmp` / `cmp_luasnip` / `LuaSnip`
2. Update `lazydev.nvim` integration for `blink.cmp`

In practice, these two items are coupled because the only remaining `nvim-cmp` reference is inside `lua/plugins/lazydev.lua`. So the cleanest change is to handle both together in one pass.

## Approach
Migrate fully to a Blink-only completion stack while preserving current behavior:
- keep `blink.cmp`
- keep `friendly-snippets`
- keep `lazydev.nvim`
- remove `nvim-cmp`, `cmp_luasnip`, and `LuaSnip` only if no remaining config depends on LuaSnip-specific snippet behavior
- replace the `lazydev` integration block with the Blink-native provider configuration

## Files to modify
- `lua/plugins/lsp/lsp.lua`
- `lua/plugins/lazydev.lua`
- `lua/plugins/blink-cmp.lua` (only if needed to host the `lazydev` provider cleanly)
- `CONFIG_CHECKLIST.md`

## Reuse
- Existing Blink setup in `lua/plugins/blink-cmp.lua`
- Existing `friendly-snippets` dependency
- Existing `lazydev.nvim` plugin and its library settings
- Blink-native lazydev provider pattern:
  - add `lazydev` to Blink sources
  - configure provider module `lazydev.integrations.blink`

## Preconditions to confirm during implementation
- [ ] There is no actual runtime use of `LuaSnip` APIs elsewhere in the config.
- [ ] There is no Blink configuration explicitly using `snippets = { preset = 'luasnip' }`.
- [ ] Snippet support can remain on Blink's default/native snippet preset with `friendly-snippets`.

## Steps
- [ ] Confirm there are no remaining meaningful `LuaSnip` usages in the config.
- [ ] Remove `LuaSnip` and `cmp_luasnip` from `lua/plugins/lsp/lsp.lua`.
- [ ] Remove the `hrsh7th/nvim-cmp` block from `lua/plugins/lazydev.lua`.
- [ ] Add or move the Blink-native `lazydev` provider configuration so Lua module completions still work under Blink.
- [ ] Keep `friendly-snippets` in the Blink stack unless you explicitly want to remove snippets entirely.
- [ ] Mark both checklist items complete if the cleanup also finishes the lazydev Blink migration.

## Verification
- Parse check: `nvim --headless '+qa'`
- Search for old completion leftovers:
  - `rg -n 'nvim%-cmp|cmp_luasnip|LuaSnip|luasnip' lua`
- Search for active Blink + lazydev integration:
  - `rg -n 'lazydev.integrations.blink|sources|providers' lua/plugins/blink-cmp.lua lua/plugins/lazydev.lua`
- Optional runtime checks in Neovim:
  - open a Lua file and verify `require("...")` completions still include lazydev suggestions
  - verify normal LSP/path/buffer/snippet completion still works

## Expected result
After this cleanup:
- Blink remains the only completion engine in active use
- `nvim-cmp`, `cmp_luasnip`, and likely `LuaSnip` are removed from the config if no longer needed
- `lazydev.nvim` is wired directly into Blink instead of `nvim-cmp`
- the two adjacent checklist items can likely be completed together
