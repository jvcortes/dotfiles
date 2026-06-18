# Per-project LSP server overrides

## Context
The user wants per-project LSP server overrides via `.nvim.lua`, matching the pattern already used for Conform formatters (`vim.g.conform_*_formatters`). A basic override mechanism already exists in `lua/config/lsp/start.lua` line 12:

```lua
local server_name = vim.g.lsp_servers and vim.g.lsp_servers[lang] or config.use
```

But it only switches between pre-configured server names — it can't accept a custom config or disable a server.

## Approach
1. Add `ts_ls` and `tsgo` as alternative servers in the `typescript` entry of `servers.lua` so the user can switch between `vtsls` (default), `ts_ls`, and `tsgo` per project.
   - **`vtsls`** (default): wraps VSCode's TypeScript extension, mature, Node.js-based, ~3GB memory on large repos
   - **`ts_ls`**: traditional Node.js LSP proxy to tsserver, simpler but slower on large projects
   - **`tsgo`**: Microsoft's native Go rewrite (TypeScript 7), ~70-300MB memory, no Node.js dependency, LSP still "in progress" but nearly feature-complete. Available via Mason (`:MasonInstall tsgo`) or npm (`@typescript/native-preview`). Requires Neovim >= 0.11.
2. Extend the override logic in `start.lua` to support three forms:
   - `vim.g.lsp_servers[lang] = "server_name"` — picks from pre-configured servers (existing behavior)
   - `vim.g.lsp_servers[lang] = { name = "...", config = {...} }` — full custom server config
   - `vim.g.lsp_servers[lang] = false` — disables LSP for that language in this project

## Files to modify
- `lua/config/lsp/servers.lua` — add `ts_ls` alternative for typescript
- `lua/config/lsp/start.lua` — extend override logic

## Steps
- [ ] Add `ts_ls` and `tsgo` as alternative servers in `servers.lua` typescript entry
- [ ] Extend `start.lua` to handle string, table, and `false` overrides
- [ ] Run `nvim --headless '+qa'` to verify clean parse
- [ ] Test override logic headlessly with mock `vim.g` values

## Verification
- `nvim --headless '+qa'` passes
- `vim.g.lsp_servers = { typescript = "ts_ls" }` switches to ts_ls
- `vim.g.lsp_servers = { typescript = "tsgo" }` switches to tsgo
- `vim.g.lsp_servers = { typescript = false }` disables typescript LSP
- `vim.g.lsp_servers = { python = { name = "pylsp", config = {} } }` uses custom config
