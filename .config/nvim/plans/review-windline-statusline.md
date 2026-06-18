# Review `windwp/windline.nvim`: keep or replace

## Context
The current statusline is provided by `windwp/windline.nvim` in `lua/plugins/statusline.lua`, with a fairly custom implementation in `lua/config/ui/statusline.lua`.

Known observations from the config review:
- The plugin is not obviously broken right now.
- The statusline config is heavily customized, so replacement cost is non-trivial.
- Some config branches are stale (for example the explorer filetypes still reference `fern`, `NvimTree`, and `lir`, while the current file explorer is `oil.nvim`).
- This checklist item is specifically about deciding whether `windline.nvim` should remain in place or whether migration effort is justified.

## Goal
Make an explicit decision:
1. **Keep Windline** and do a small cleanup only, or
2. **Replace Windline** with a better-supported statusline plugin and migrate the current features.

## Decision criteria
Keep `windline.nvim` if all of the following are true:
- It still loads cleanly and behaves correctly in daily use.
- There are no active maintenance or compatibility concerns severe enough to force migration.
- The custom layout is valuable enough that migration cost outweighs the benefit.

Replace `windline.nvim` if one or more of the following are true:
- It shows compatibility issues with current Neovim.
- It is effectively too niche/stale for confident long-term maintenance.
- The current config is harder to maintain than rebuilding the same UI in a more common plugin.
- A replacement can cover the same essentials: mode, file info, diagnostics, LSP name, git diff, branch, quickfix/trouble handling, and explorer handling.

## Candidate outcomes
### Option A: Keep Windline
If the review favors keeping it:
- Keep `lua/plugins/statusline.lua` as-is.
- Do only targeted cleanup in `lua/config/ui/statusline.lua`:
  - remove stale explorer filetypes
  - verify Trouble/quickfix handling still matches current plugin filetypes
  - optionally modernize any deprecated API usage encountered nearby
- Mark the checklist item complete with a short note that Windline remains by choice.

### Option B: Replace Windline
If the review favors replacement:
- Prefer a mainstream replacement such as:
  - `nvim-lualine/lualine.nvim` for simpler migration, or
  - `rebelot/heirline.nvim` for highly custom layouts closer to the current design
- Recreate only the current required features first:
  - mode indicator
  - file name / modified marker / cursor position / progress
  - diagnostics
  - LSP name or filetype fallback
  - git diff stats and branch
  - quickfix/trouble variant
  - explorer variant matching `oil.nvim` if still desired
- Remove Windline only after the replacement is validated.

## Recommended investigation steps
- [x] Review the current behavior and decide what parts of the statusline are actually important to preserve.
- [x] Confirm whether `windline.nvim` is still maintained enough for your comfort level.
- [x] Compare migration targets:
  - `lualine.nvim` if you want lower complexity
  - `heirline.nvim` if you want maximum layout flexibility
- [x] Estimate migration scope by mapping current Windline sections to replacement equivalents.
- [x] Choose either “keep + cleanup” or “replace + migrate”.

## Review findings
- `windline.nvim` is currently loading cleanly: `nvim --headless '+qa'` passed.
- The installed/locked Windline checkout is recent enough for a “keep for now” decision:
  - local checkout: `2e83922` (`2025-10-22`, `fix: tmuxline don't need use -g`)
- The current statusline is heavily customized in `lua/config/ui/statusline.lua`; replacing it would require reimplementing:
  - mode indicator
  - file info / modified marker / cursor position / progress
  - diagnostics
  - LSP name / filetype fallback
  - git diff + branch
  - quickfix / Trouble special case
  - explorer special case
- There are stale branches in the current Windline config:
  - explorer filetypes still target `fern`, `NvimTree`, and `lir`
  - current explorer plugin is `oil.nvim`, which uses the `oil` filetype
  - quickfix special-case uses `Trouble`, while the current `trouble.nvim` filetype is `trouble`

## Review outcome
**Recommendation: keep `windwp/windline.nvim` for now, and do a targeted cleanup rather than a migration.**

Rationale:
- It is not broken or obviously abandoned in a way that forces immediate migration.
- Your config is custom enough that replacing it would be a medium migration, not a trivial swap.
- The most concrete issues found are stale filetype branches, which can be fixed locally without changing plugins.

## Follow-up execution path
If you want to act on this review, the smallest justified cleanup is:
1. Keep `lua/plugins/statusline.lua` unchanged.
2. Update `lua/config/ui/statusline.lua` to:
   - replace stale explorer filetypes with `oil`
   - update Trouble handling from `Trouble` to `trouble` if you still want that special case
3. Mark the checklist item complete with a note like “Kept Windline; cleaned stale filetype branches.”

## Concrete checks to run during execution
- Headless parse check: `nvim --headless '+qa'`
- Search for statusline-specific stale references:
  - `fern`
  - `NvimTree`
  - `lir`
  - `Trouble`
- Open buffers interactively and confirm the current statusline still works for:
  - normal editing
  - a git repo
  - LSP-attached buffer
  - quickfix list
  - Trouble view
  - Oil buffer

## Minimal execution strategy
1. Decide whether the plugin should stay or go.
2. If staying, do the smallest cleanup needed and stop.
3. If replacing, create a migration plan before editing any statusline code.
