# Fix diagnostic keymaps (`[d` / `]d`)

## Context
The current LSP mappings in `lua/config/mappings/lsp.lua` bind:
- `[d` to `vim.diagnostic.get_next`
- `]d` to `vim.diagnostic.get_prev`

Those functions return diagnostic items; they do not move the cursor. So the mappings are named like navigation keys but currently do not actually jump between diagnostics.

## Approach
Keep the existing keybinding scheme and descriptions, but switch the implementation to real diagnostic navigation.

Recommended modern fix:
- map `[d` and `]d` to `vim.diagnostic.jump(...)`
- use `count = -1` / `count = 1` so the cursor actually moves
- keep `<leader>vd` using `vim.diagnostic.open_float`

This avoids relying on older `goto_next` / `goto_prev` helpers and matches current Neovim guidance.

## Files to modify
- `lua/config/mappings/lsp.lua`
- `CONFIG_CHECKLIST.md`

## Reuse
- Existing `LspAttach` autocmd in `lua/config/mappings/lsp.lua`
- Existing diagnostic float mapping `<leader>vd`

## Steps
- [ ] Replace the `[d` mapping with a real backward diagnostic jump.
- [ ] Replace the `]d` mapping with a real forward diagnostic jump.
- [ ] Keep mapping descriptions aligned with actual behavior.
- [ ] Mark the checklist item complete in `CONFIG_CHECKLIST.md`.

## Verification
- Parse check: `nvim --headless '+qa'`
- Search check: ensure `vim.diagnostic.get_next` / `vim.diagnostic.get_prev` are no longer used for those mappings.
- Interactive check in a file with diagnostics:
  - `]d` moves to the next diagnostic
  - `[d` moves to the previous diagnostic
  - `<leader>vd` still opens the float for the current line/location

## Expected result
After this change, the diagnostic keymaps will finally match their descriptions and work as real navigation commands.
