# Clean up `conform.nvim` formatter dependencies

## Context
Current `conform.nvim` config in `lua/plugins/conform.lua` declares:
- `lua` → `stylua`
- `python` → `isort`, `ruff_fix`, `ruff_format`
- `markdown` → `prettierd`, `prettier` (`stop_after_first = true`)

Current health status:
- missing: `stylua`
- missing: `isort`
- missing: `prettier`
- missing: `prettierd`
- available: `ruff_fix`
- available: `ruff_format`

So the config currently mixes tools you have with tools you do not.

## Goal
Make `conform.nvim` formatter selection project-aware, so the global config provides sane defaults while individual repositories can override which formatters they use.

## Recommended direction
Prefer **project-overridable formatter defaults** over a rigid global formatter list.

Why:
- different projects may legitimately require different formatter stacks
- you already have `exrc` enabled, so project-local `.nvim.lua` overrides fit your config style well
- Conform supports formatter lists cleanly enough that global defaults can delegate to project-local choices
- this lets you keep a reasonable default while avoiding one-size-fits-all formatter assumptions

## Approach
Refactor `conform.nvim` so formatter lists come from global defaults that can be overridden per project.

Recommended shape:
- keep a global default formatter table in `lua/plugins/conform.lua`
- read per-project overrides from variables (for example `vim.g.conform_python_formatters`) when present
- use `.nvim.lua` files in repositories to override formatter choices per project

Most likely cleanup path:
- set a global Python default (for example Ruff-based)
- allow projects to override Python formatters to use `isort`, Ruff, both, or none
- decide whether Lua and Markdown should also be made project-overridable or simply cleaned up globally
- reduce health warnings by removing globally declared tools you do not want as defaults on this machine

## Files to modify
- `lua/plugins/conform.lua`
- `CONFIG_CHECKLIST.md`

## Reuse
- Existing `conform.setup(...)` in `lua/plugins/conform.lua`
- Existing `ruff_fix` / `ruff_format` tools already available on this machine
- Existing `stop_after_first = true` behavior for fallback chains where you keep multiple tools
- Existing `vim.opt.exrc = true` setting, which enables project-local `.nvim.lua` overrides

## Decision points
### Python
- define a global default (likely Ruff-based)
- allow project-local override via `.nvim.lua`, for example:
  - USER ANSWER: `ruff` and `isort` as default

### Lua
- decide whether Lua formatting should stay globally declared, be project-overridable, or be removed until `stylua` is available
    USER ANSWER: keep `stylua`, I will install it

### Markdown
- decide whether Markdown formatting should stay globally declared, be project-overridable, or be removed until `prettier` / `prettierd` are available
    USER ANSWER: `prettierd` as default

## Steps
- [ ] Define global default formatter lists in `lua/plugins/conform.lua`.
- [ ] Make formatter lists project-overridable via variables read by the global config (for example `vim.g.conform_python_formatters`).
- [ ] Remove rigid global assumptions that do not match this machine unless you explicitly want them as defaults.
- [ ] Add a short documented example in the config comments or plan for how a project `.nvim.lua` can override formatter choices.
- [ ] Mark the checklist item complete in `CONFIG_CHECKLIST.md`.

## Verification
- Parse check: `nvim --headless '+qa'`
- Health check: `:checkhealth conform`
- Confirm global defaults behave as expected on this machine
- Confirm a sample `.nvim.lua` override can change formatter selection for a project

## Expected result
After this cleanup:
- `conform.nvim` will have sane global defaults
- per-project `.nvim.lua` files will be able to override formatter choices cleanly
- Python formatter selection can vary by repository without editing your main config
- global formatter warnings can be reduced by removing defaults you do not want on this machine
