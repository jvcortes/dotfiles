# Replace deprecated `vim.loop` usage with `vim.uv`

## Context
The remaining deprecated `vim.loop` references in this config are:
- `lua/config/lazy.lua`
- `lua/plugins/treesitter.lua`

Current usages:
- bootstrap check for Lazy: `vim.loop.fs_stat(lazypath)`
- large-file guard in Treesitter: `pcall(vim.loop.fs_stat, ...)`

Modern Neovim recommends `vim.uv` instead of `vim.loop`.

## Approach
Perform a minimal API modernization only:
- replace `vim.loop` with `vim.uv`
- keep logic and control flow unchanged
- do not refactor surrounding code beyond the namespace swap

## Files to modify
- `lua/config/lazy.lua`
- `lua/plugins/treesitter.lua`
- `CONFIG_CHECKLIST.md`

## Reuse
- Existing bootstrap logic in `lua/config/lazy.lua`
- Existing Treesitter large-file guard in `lua/plugins/treesitter.lua`

## Steps
- [ ] Replace `vim.loop.fs_stat` with `vim.uv.fs_stat` in `lua/config/lazy.lua`.
- [ ] Replace `vim.loop.fs_stat` with `vim.uv.fs_stat` in `lua/plugins/treesitter.lua`.
- [ ] Leave all surrounding behavior unchanged.
- [ ] Mark the checklist item complete in `CONFIG_CHECKLIST.md`.

## Verification
- Parse check: `nvim --headless '+qa'`
- Search check:
  - `rg -n 'vim\.loop|vim\.uv' lua/config/lazy.lua lua/plugins/treesitter.lua`
- Optional health check:
  - `:checkhealth vim.deprecated`

## Expected result
After this change:
- deprecated `vim.loop` references are removed from your config
- behavior remains the same
- the config better matches current Neovim API guidance
