# Review current LSP setup

## Context
Your LSP configuration is already mostly using the modern Neovim LSP flow:
- `vim.lsp.config(...)`
- `vim.lsp.enable(...)`

Current structure:
- `lua/config/lsp/init.lua` still loads `config.lsp.custom` and `config.lsp.start`
- `lua/config/lsp/custom.lua` is now effectively empty after removing legacy `pyls`
- `lua/config/lsp/start.lua` drives server selection from `lua/config/lsp/servers.lua`
- `lua/plugins/lsp/lsp.lua` still declares some dependencies that may belong to older setup phases

So the next review is not about changing server choices, but about cleaning the LSP bootstrap so it consistently reflects the current API and only keeps pieces that are still serving a purpose.

## Approach
Review the LSP setup narrowly and preserve current behavior:
- keep the current server selection model from `lua/config/lsp/servers.lua`
- keep `basedpyright`/`pylsp` and `lua_ls` behavior unchanged
- keep the project override mechanism via `vim.g.lsp_servers`
- remove or simplify only the parts that are clearly leftover from the old setup

This item should avoid mixing in unrelated completion cleanup unless a dependency is obviously dead and only exists for the old LSP bootstrap.

## Files to review / possibly modify
- `lua/config/lsp/init.lua`
- `lua/config/lsp/custom.lua`
- `lua/config/lsp/start.lua`
- `lua/plugins/lsp/lsp.lua`
- `CONFIG_CHECKLIST.md`

## Reuse
- Existing server table in `lua/config/lsp/servers.lua`
- Existing enable loop in `lua/config/lsp/start.lua`
- Existing capabilities from `blink.cmp`
- Existing diagnostics config in `lua/config/lsp/start.lua`

## Current observations
- `lua/config/lsp/custom.lua` is empty but still required by `lua/config/lsp/init.lua`
- `lua/config/lsp/start.lua` still has `local lspconfig = require('lspconfig')`, but the file uses `vim.lsp.config()` / `vim.lsp.enable()` directly
- `mason.nvim` is actively used in `start.lua`, but `mason-lspconfig.nvim` does not appear to be referenced in your own config
- `neovim/nvim-lspconfig` itself is still useful because modern `vim.lsp.config()` consumes server configs provided by that plugin
- `LuaSnip` / `cmp_luasnip` are listed in the LSP plugin spec, but those look more related to the separate completion cleanup item than to LSP bootstrap correctness

## Recommended decision boundaries
### In scope
- Remove empty or unused LSP bootstrap pieces
- Keep the current startup flow readable and internally consistent
- Remove `mason-lspconfig.nvim` only if it is confirmed unnecessary for your current setup

### Out of scope for this item
- Reworking completion/snippet dependencies unless they are directly required by LSP bootstrap
- Changing server defaults or adding new servers
- Changing keymaps or diagnostics behavior

## Steps
- [ ] Confirm which LSP bootstrap pieces are still active versus leftover.
- [ ] Remove the `config.lsp.custom` load if the module remains empty.
- [ ] Remove unused imports from `lua/config/lsp/start.lua` if they are no longer needed.
- [ ] Decide whether `mason-lspconfig.nvim` is still necessary in `lua/plugins/lsp/lsp.lua`; remove it only if confirmed unused.
- [ ] Leave `neovim/nvim-lspconfig` in place because it still supplies server definitions for the modern config path.
- [ ] Update `CONFIG_CHECKLIST.md` when the review is complete.

## Verification
- Parse check: `nvim --headless '+qa'`
- Search for stale bootstrap references:
  - `rg -n 'config.lsp.custom|require\("lspconfig"\)|require\('"'"'lspconfig'"'"'\)|mason%-lspconfig|mason_lspconfig' lua`
- Confirm maintained LSP flow still remains:
  - `rg -n 'vim\.lsp\.config|vim\.lsp\.enable|mason\.setup|blink\.get_lsp_capabilities' lua/config/lsp`

## Expected result
After this review/cleanup:
- the LSP bootstrap will match the current API style more closely
- empty/unused legacy scaffolding will be gone
- active behavior should remain the same
- deeper completion/snippet cleanup can happen later as a separate checklist item
