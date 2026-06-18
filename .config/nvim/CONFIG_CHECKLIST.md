# Neovim Config Cleanup Checklist

Track progress while reviewing deprecated, abandoned, or outdated parts of this config.

## Plugin replacements / removals
- [x] Replace `phaazon/hop.nvim` with a maintained alternative (`smoka7/hop.nvim`)
  - Note: run `:Lazy sync` to refresh the installed checkout / lockfile if desired.
- [x] Remove `nvim-treesitter/playground`; use built-in Neovim inspection tools instead (`:Inspect`, `:InspectTree`, `:EditQuery`)
- [x] Review whether `windwp/windline.nvim` should stay or be replaced — Kept Windline; cleaned stale filetype branches (`fern`/`NvimTree`/`lir` → `oil`, `Trouble` → `trouble`)

## LSP / diagnostics cleanup
- [x] Remove legacy `pyls` config and keep maintained Python LSP choices only — removed `pyls`; kept `basedpyright` as default and `pylsp` as the maintained alternative
- [x] Review mixed old/new LSP setup (`lspconfig.configs` vs `vim.lsp.config` / `vim.lsp.enable`) — removed empty `config.lsp.custom`, dropped unused `lspconfig` import, and removed unused `mason-lspconfig.nvim`
- [x] Fix diagnostic keymaps so `[d` and `]d` actually jump between diagnostics — switched to real `vim.diagnostic.jump(...)` navigation and aligned the key descriptions

## Plugin config cleanup
- [x] Remove `avante.nvim` entirely — plugin spec deleted since it is no longer used
- [x] Remove leftover `nvim-cmp` / `cmp_luasnip` / `LuaSnip` config if `blink.cmp` fully replaces them — removed old completion-engine dependencies and the last `nvim-cmp`-specific config hooks
- [x] Update `lazydev.nvim` integration for `blink.cmp` instead of `nvim-cmp` — `lazydev` now registers as a Blink provider for Lua files
- [x] Remove stale Treesitter config entries that rely on missing plugins (for example `autotag` without `nvim-ts-autotag`) — removed stale Treesitter `autotag`/`autopairs` module flags and re-added `nvim-ts-autotag` as its own plugin using the supported setup path
- [x] Remove stale statusline filetype branches (`fern`, `NvimTree`, `lir`) if `oil.nvim` is the only explorer now — done as part of Windline review (item #3)

## Duplicate / conflicting config
- [x] Consolidate Alpha dashboard setup (currently configured in more than one place) — kept `config.dashboard` as the single Alpha setup source and removed the competing `theta` setup
- [x] Consolidate Telescope keymaps/config so mappings are defined once — moved Telescope mappings to `config/mappings/telescope.lua` and removed inline plugin keymaps
- [x] Fix duplicated Telescope mapping assignments (for example `<leader>fg`) — removed duplicate inline assignments so `<leader>fg` is defined once

## Neovim API modernization
- [x] Replace deprecated `vim.loop` usage with `vim.uv` — updated the remaining `fs_stat` calls in Lazy bootstrap and Treesitter large-file checks

## External tools / health warnings
- [x] Decide whether to keep `none-ls` + `vale`; otherwise remove the integration — kept `none-ls`; linters are now optional via a declared source list with PATH checks, `vale` is no longer mandatory
- [x] Install or remove missing formatter dependencies used by `conform.nvim` — made formatter lists project-overridable via `vim.g.conform_<ft>_formatters` variables; defaults: Python → `isort`+Ruff, Lua → `stylua`, Markdown → `prettierd`; user to install `stylua`/`isort`/`prettierd` separately
- [x] Resolve Treesitter parser health errors (`bicep`, `jsdoc`, `properties`) — removed stale parser artifacts for unmanaged languages so Treesitter health no longer reports load errors

## Notes
- Current likely drop-in `hop` replacement: `smoka7/hop.nvim`
- More opinionated but modern non-drop-in motion alternative: `folke/flash.nvim`
