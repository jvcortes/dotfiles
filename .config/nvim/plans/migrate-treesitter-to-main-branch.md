# Migrate nvim-treesitter from frozen master to main branch

## Context
You're on **Neovim 0.12.2** but `nvim-treesitter` is pinned to `version = 'v0.*.*'` which locks you to the **frozen `master` branch** — compatible only with Neovim 0.11. This causes `attempt to call method 'range' (a nil value)` errors in `query_predicates.lua` when opening Markdown buffers, because the old plugin's custom query predicates use a match format incompatible with Neovim 0.12's treesitter API.

The `nvim-treesitter` project has moved active development to the **`main` branch**, which is a **full rewrite** for Neovim 0.12+. It's a different plugin with a different API — it's now purely a parser/query manager, not a feature framework.

## Key differences: master → main

| Aspect | master (current) | main (target) |
|---|---|---|
| Branch / version | `version = 'v0.*.*'` (frozen) | `branch = 'main'` |
| Setup API | `require('nvim-treesitter.configs').setup(opts)` | `require('nvim-treesitter').setup({ install_dir = ... })` |
| Highlighting | `highlight = { enable = true, ... }` in opts | **Gone** — use Neovim's native `vim.treesitter.start()` per filetype |
| Indentation | `indent = { enable = false }` in opts | **Gone** — use `vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"` per filetype |
| Folds | `incremental_selection`, etc. | **Gone** — use Neovim's native `vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'` |
| Refactor module | `refactor = { highlight_definitions = ... }` | **Gone** — use LSP `vim.lsp.buf.document_highlight()` instead |
| Parser management | `ensure_installed`, `ignore_install`, `sync_install`, `auto_install` | **Gone** — use `:TSInstall` / `require('nvim-treesitter').install(...)` |
| Lazy loading | `event = 'BufReadPost'` | **Not supported** — must use `lazy = false` |
| External deps | None beyond a C compiler | **`tree-sitter-cli` >= 0.26.1** required (via system package manager, not npm) |

## What stays the same
- `build = ':TSUpdate'` — still the recommended build step
- `nvim-ts-autotag` — depends on `nvim-treesitter/nvim-treesitter` for queries only, no API calls into it
- The plugin spec file remains `lua/plugins/treesitter.lua`
- No other files in the config reference nvim-treesitter directly

## Approach
1. **Update the plugin spec** in `lua/plugins/treesitter.lua` to use `branch = 'main'` with the new minimal API.
2. **Add a `FileType` autocommand** (or a small helper module) to enable treesitter highlighting for your configured languages, since the plugin no longer does this automatically.
3. **Remove all old opts** (`highlight`, `indent`, `refactor`, `ensure_installed`, `ignore_install`, `sync_install`, `auto_install`).
4. **Ensure `tree-sitter-cli` is available** on the system.
5. **Run `:TSUpdate`** after the switch to reinstall parsers under the new scheme.

## Files to modify
- `lua/plugins/treesitter.lua` — rewrite the plugin spec
- `lua/config/treesitter.lua` (new) — optional helper module for enabling highlighting per filetype via `FileType` autocommands

## Steps
- [ ] Check if `tree-sitter-cli` >= 0.26.1 is installed; if not, note the install command.
- [ ] Rewrite `lua/plugins/treesitter.lua`:
  - remove `version = 'v0.*.*'`, add `branch = 'main'`
  - change `event = 'BufReadPost'` to `lazy = false`
  - remove `dependencies = {}`
  - replace `opts` with just `install_dir` if non-default desired (default is fine)
  - replace `config` function to call `require('nvim-treesitter').setup(opts)`
- [ ] Add a `FileType` autocommand (in `lua/config/treesitter.lua` or inline) to enable `vim.treesitter.start()` for your languages (`python`, `markdown`, `json`, `sql`, `xml`).
- [ ] Keep the large-file disable logic — move it to the `FileType` autocommand or use `vim.treesitter.start()` conditionally.
- [ ] Run `nvim --headless '+qa'` to verify clean parse.
- [ ] Run `:TSUpdate` in a live session to reinstall parsers under the new scheme.
- [ ] Open a Markdown file to confirm the `range` error is gone.

## Verification
- `nvim --headless '+qa'` passes
- `:checkhealth nvim-treesitter` shows parsers installed correctly
- Opening a Markdown buffer no longer produces `attempt to call method 'range'` errors
- Treesitter highlighting still works for Python, Markdown, JSON, SQL, XML files
- `nvim-ts-autotag` still functions (test with HTML/JSX)
