# Adopt evil_lualine style for lualine

## Context
You want to switch the lualine config to follow the [evil_lualine](https://github.com/nvim-lualine/lualine.nvim/blob/master/examples/evil_lualine.lua) pattern while keeping the customizations already in place (ANSI-sourced colors, popup suppression, custom extensions for qf/trouble/oil, responsive breakpoint behavior).

## What is evil_lualine
The evil_lualine example is an "eviline"-style statusline that:
- **Uses only two sections**: `lualine_c` (left) and `lualine_x` (right), with all other sections (`a`, `b`, `y`, `z`) left empty.
- **Disables all separators** (both component and section).
- **Uses a minimal theme** that only styles the `c` section, since that's the only one rendered.
- **Inserts a `%=` mid-divider** to split the left half from a centered LSP name component.
- **Components (left to right)**: mode bar `▊`, mode icon ``, filesize, filename, location, progress, diagnostics, `%=`, LSP name, encoding, fileformat, branch, diff, mode bar `▊`.

## Key differences from current config

| Aspect | Current config | Evil style |
|---|---|---|
| Section layout | Uses `a`, `b`, `c`, `x`, `y`, `z` | Only `c` (left) and `x` (right); others empty |
| Theme | Full per-mode theme object (`normal`, `insert`, `visual`, etc.) | Minimal theme — only `normal.c` and `inactive.c` |
| Mode indicator | `▊` bar + text label (`NORMAL`, `INSERT`, etc.) | `▊` bar + icon `` (no text label) |
| Mid section | None — left and right flow naturally | `%=` divider + centered LSP name |
| Encoding/fileformat | Not shown | Shown on right side |
| Responsive width | `cond`-based show/hide at 90 columns | `cond` at 80 columns (`hide_in_width`) |

## What to keep from current config
- ANSI/highlight-sourced palette (no hardcoded hex)
- Popup suppression for `noice`, `TelescopePrompt`, `TelescopeResults`
- Custom extensions for `qf`, `trouble`, `oil` (these already work and match the prior Windline look)
- `globalstatus = false` (per-window statuslines)
- Inactive sections
- Refresh event list (includes `DiagnosticChanged`, `LspAttach`, `LspDetach`)
- Git info sourced from gitsigns (`vim.b.gitsigns_status_dict`, `vim.b.gitsigns_head`)

## What to adopt from evil_lualine
- Restructure to use only `lualine_c` / `lualine_x` with `ins_left` / `ins_right` builders
- Simplify the theme to only define the `c` section (since `a`, `b`, `y`, `z` are empty)
- Add `%=` mid-divider to center the LSP name component
- Replace the mode text label with the mode icon ``
- Add encoding and fileformat components on the right side
- Use the evil-style `hide_in_width` condition (can keep 90 or adopt 80 — your call)

## Files to modify
- `lua/config/ui/lualine.lua` — rewrite the `M.setup()` function to follow the evil structure

No other files need to change; the plugin spec and extensions stay as-is.

## Steps
- [x] Rewrite `lua/config/ui/lualine.lua` to follow the evil_lualine structure.
- [x] Run `nvim --headless '+qa'` to verify parse.
- [x] Run headless render probes for default, qf, oil, trouble, telescope, and noice filetypes.

## Verification
- `nvim --headless '+qa'` passes
- headless render probes confirm:
  - default filetype renders a statusline
  - `TelescopePrompt`, `TelescopeResults`, `noice` return `nil`
  - `qf`, `trouble`, `oil` render their custom extensions
- manual visual pass recommended for final confirmation
