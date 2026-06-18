# Migrate statusline from Windline to Lualine

## Context
You disabled `windwp/windline.nvim` because popup buffers (notably Noice cmdline and Telescope prompt windows) started showing an unwanted scratch-buffer statusline. The goal is to replace Windline with plain `nvim-lualine/lualine.nvim` while keeping the current look and behavior as close as practical.

Current statusline state I found:
- `lua/plugins/statusline.lua` is still the statusline plugin entry point, but it is fully commented out and currently points at Windline.
- `lua/config/ui/statusline.lua` contains the existing Windline design we want to preserve as closely as possible.
- The current design has four logical variants:
  - default editor statusline
  - quickfix / trouble statusline
  - oil explorer statusline
  - popup suppression for `noice` and `TelescopePrompt`
- The current layout is per-window, not global, and depends on active vs inactive sections.
- The current theme uses custom mode colors plus icons, file info, diagnostics, LSP name / filetype, git diff, branch, location, and progress.

## Approach
Replace Windline with Lualine in two layers:

1. **Plugin swap**
   - replace the commented Windline plugin spec in `lua/plugins/statusline.lua` with `nvim-lualine/lualine.nvim`
   - keep `nvim-web-devicons`
   - load a new config module dedicated to Lualine

2. **Closest-practical parity config**
   - create `lua/config/ui/lualine.lua`
   - reproduce the current layout with Lualine sections and a few small custom Lua components
   - keep `globalstatus = false` so active/inactive windows still behave like the current setup
   - suppress statuslines entirely for popup filetypes (`noice`, `TelescopePrompt`) via Lualine’s `disabled_filetypes.statusline`
   - use built-in Lualine extension support where it reduces code, but prefer custom extension tables/components when the existing Windline behavior is more specific than the stock extension

This keeps the migration narrow: change the statusline implementation, not the rest of the UI.

## Files to modify
- `lua/plugins/statusline.lua`
- `lua/config/ui/lualine.lua` (new)
- `lua/config/ui/statusline.lua` (remove after cutover, or leave temporarily until migration is confirmed)
- optionally `CONFIG_CHECKLIST.md` only if you want to track this follow-up separately

## Reuse
From the current Windline config (`lua/config/ui/statusline.lua`):
- mode color mapping semantics to preserve, sourced from ANSI-style terminal color slots / existing highlight groups rather than hard-coded palette hex values:
  - Normal → terminal red on terminal black
  - Insert → terminal green on terminal black
  - Visual → terminal yellow on terminal black
  - Replace → terminal blue / bright-blue on terminal black
  - Command → terminal magenta on terminal black
- responsive breakpoint logic at width `90`
- default information architecture:
  - left: mode + file block
  - middle/right: diagnostics, location, LSP/filetype, git diff, branch, progress
- quickfix title source:
  - `vim.fn.getqflist({ title = 0 }).title`
- Oil filetype handling:
  - current directory / file context
- popup filetypes already identified:
  - `noice`
  - `TelescopePrompt`

From Lualine itself:
- `disabled_filetypes.statusline` for popup suppression
- built-in components: `diagnostics`, `diff`, `branch`, `filename`, `filetype`, `progress`, `location`
- built-in extension mechanism, including shipped extensions for:
  - `quickfix`
  - `oil`
  - `trouble`
- custom component / custom extension table support for closer parity where built-ins are too generic

## Steps
- [ ] Replace the old Windline plugin spec in `lua/plugins/statusline.lua` with a Lualine spec.
- [ ] Add `lua/config/ui/lualine.lua` with a custom Lualine setup.
- [ ] Port the default statusline first:
  - mode colors and separators
  - filename / size / modified state
  - diagnostics counts
  - location + progress
  - LSP name fallback to filetype
  - git diff + branch
- [ ] Recreate the width-sensitive behavior around the current `90` column breakpoint using Lualine `cond`/custom components.
- [ ] Recreate special filetype handling:
  - quickfix / trouble variant
  - oil variant
  - popup suppression for `noice` and `TelescopePrompt`
- [ ] Decide whether `quickfix`, `oil`, and `trouble` should use stock Lualine extensions or local custom extension tables for closer parity.
- [ ] Remove or retire the old Windline config module once the new Lualine setup is confirmed.
- [ ] Run a quick visual pass in normal buffers, inactive splits, Oil, Trouble, quickfix, Telescope, and Noice cmdline.

## Verification
- Start Neovim normally and confirm the statusline renders without Windline enabled.
- Check that popup buffers do **not** show a scratch statusline:
  - Noice cmdline
  - Telescope prompt
- Check default editor windows:
  - active window shows mode-colored left section
  - inactive window has simplified styling
  - modified flag, file name, branch, diff, diagnostics, location, and progress still update
- Check special buffers:
  - `:Oil`
  - `:Trouble diagnostics toggle`
  - `:copen`
- Run:
  - `nvim --headless '+qa'`
- If needed, compare visually against the current Windline layout and adjust only the custom components/separators.

## Notes / likely implementation choices
- Lualine has no built-in Rose Pine Moon theme file, so the closest match will likely come from a small custom theme table or setup helper.
- Per your preference, do **not** hard-code theme hex colors in that table; instead source colors from ANSI-style terminal slots / existing highlights (for example `vim.g.terminal_color_*` and/or resolved highlight groups) so mode colors stay palette-agnostic.
- For parity, custom components will probably be needed for:
  - exact mode label styling
  - file size placement
  - LSP name fallback behavior
  - quickfix title / totals
- For maintainability, use Lualine built-ins wherever they already match the current behavior closely.
