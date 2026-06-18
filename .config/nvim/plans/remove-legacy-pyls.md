# Remove legacy `pyls` config

## Context
Your Python LSP config currently supports three server entries in `lua/config/lsp/servers.lua`:
- `basedpyright` (current default via `use = 'basedpyright'`)
- `pylsp`
- `pyls`

There is also a custom legacy server definition in `lua/config/lsp/custom.lua` that registers `pyls` through `lspconfig.configs`.

This means the config still carries support for the old, unmaintained `pyls` server even though the active default is already `basedpyright` and `pylsp` is the maintained community fork.

## Approach
Remove only the legacy `pyls` path while preserving the current Python LSP behavior:
- keep `basedpyright` as the default
- keep `pylsp` as the maintained fallback option
- remove the custom `pyls` registration and the `pyls` server entry
- leave the broader LSP startup architecture unchanged for now

This keeps the change focused on checklist item #4 without mixing it with the later “mixed old/new LSP setup” cleanup.

## Files to modify
- `lua/config/lsp/custom.lua`
- `lua/config/lsp/servers.lua`
- `CONFIG_CHECKLIST.md`

## Reuse
- Existing Python LSP selection model in `lua/config/lsp/servers.lua`
- Existing runtime enable flow in `lua/config/lsp/start.lua`
- Existing project override mechanism via `vim.g.lsp_servers`

## Steps
- [ ] Remove the legacy `pyls` custom registration from `lua/config/lsp/custom.lua`.
- [ ] Remove the `pyls` server entry from the Python server list in `lua/config/lsp/servers.lua`.
- [ ] Keep `basedpyright` as the default `use` target and keep `pylsp` available as the maintained alternative.
- [ ] Mark the checklist item complete in `CONFIG_CHECKLIST.md` with a note that `pyls` was removed and `basedpyright`/`pylsp` remain.

## Verification
- Parse check: `nvim --headless '+qa'`
- Search for remaining legacy references: `rg -n 'pyls' lua`
- Confirm maintained Python servers still remain in config: `rg -n 'basedpyright|pylsp' lua/config/lsp`

## Expected result
After this change:
- `pyls` is fully removed from the config
- Python LSP support still works through `basedpyright` by default
- `pylsp` remains as an explicit maintained alternative
- the later LSP architecture cleanup can be handled separately without reintroducing legacy server support
