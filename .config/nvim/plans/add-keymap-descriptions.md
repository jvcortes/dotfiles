# Add `desc` to all keybindings missing which-key helper text

## Context
which-key.nvim uses the `desc` field in keymap opts to display human-readable labels. Many keymaps across the config are missing this field, making which-key show raw key sequences instead of descriptions.

## Files already complete (all have `desc`)
- `lua/config/mappings/lsp.lua` ✓
- `lua/plugins/oil.lua` ✓
- `lua/plugins/flash.lua` ✓
- `lua/plugins/persistence.lua` ✓
- `lua/plugins/conform.lua` ✓

## Files needing `desc` added

### 1. `lua/config/mappings/telescope.lua` (11 keymaps)
| Key | Description |
|---|---|
| `<leader>bb` | Find buffers |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fs` | Grep string |
| `<leader>pf` | Grep string (input) |
| `<leader>fh` | Help tags |
| `<leader>fr` | Recent files |
| `<leader>gf` | Git files |
| `<leader>mp` | Man pages |
| `<leader>vc` | Colorschemes |
| `<leader>vx` | Commands |

### 2. `lua/config/mappings/plugin_manager.lua` (1 keymap)
| Key | Description |
|---|---|
| `<leader>ll` | Lazy home |

### 3. `lua/config/mappings/nvim/editing.lua` (22 keymaps)
| Key | Mode | Description |
|---|---|---|
| `J` | v | Move line down |
| `K` | v | Move line up |
| `J` | n | Join lines |
| `<C-d>` | n | Half page down |
| `<C-u>` | n | Half page up |
| `n` | n | Next search (centered) |
| `N` | n | Prev search (centered) |
| `<leader>y` | n | Yank to clipboard |
| `<leader>y` | v | Yank to clipboard |
| `<leader>Y` | n | Yank line to clipboard |
| `<leader>d` | n | Delete to void register |
| `<leader>d` | v | Delete to void register |
| `<leader>q` | n | Record macro |
| `<leader>q` | v | Record macro |
| `<leader><C-f>` | n | Format buffer |
| `<C-k>` | n | Next quickfix |
| `<C-j>` | n | Prev quickfix |
| `<leader>k` | n | Next loclist |
| `<leader>j` | n | Prev loclist |
| `<leader>sw` | n | Change inner word |
| `<leader>sb` | n | Substitute word |
| `<leader>x` | n | Make executable |

### 4. `lua/config/mappings/nvim/shortcuts.lua` (2 keymaps)
| Key | Description |
|---|---|
| `<leader>crc` | Edit vimrc |
| `<leader>ce` | Open config |

### 5. `lua/config/mappings/nvim/viewing.lua` (1 keymap)
| Key | Description |
|---|---|
| `<leader><C-x>` | Open image viewer |

### 6. `lua/plugins/harpoon.lua` (8 keymaps)
| Key | Description |
|---|---|
| `<leader>a` | Harpoon add |
| `<C-e>` | Harpoon menu |
| `<leader>1` | Harpoon file 1 |
| `<leader>2` | Harpoon file 2 |
| `<leader>3` | Harpoon file 3 |
| `<leader>4` | Harpoon file 4 |
| `<C-S-P>` | Harpoon prev |
| `<C-S-N>` | Harpoon next |

### 7. `lua/plugins/dap.lua` (7 keymaps)
| Key | Description |
|---|---|
| `<leader>dt` | Toggle breakpoint |
| `<leader>dc` | Continue / Start |
| `<leader>do` | Step over |
| `<leader>di` | Step into |
| `<leader>dO` | Step out |
| `<leader>dq` | Terminate |
| `<leader>du` | Toggle DAP UI |

### 8. `lua/plugins/undotree.lua` (1 keymap)
| Key | Description |
|---|---|
| `<leader><F5>` | Undo tree |

## Total: 53 keymaps across 8 files

## Steps
- [ ] Add `desc` to all keymaps in `lua/config/mappings/telescope.lua`
- [ ] Add `desc` to keymap in `lua/config/mappings/plugin_manager.lua`
- [ ] Add `desc` to all keymaps in `lua/config/mappings/nvim/editing.lua`
- [ ] Add `desc` to all keymaps in `lua/config/mappings/nvim/shortcuts.lua`
- [ ] Add `desc` to keymap in `lua/config/mappings/nvim/viewing.lua`
- [ ] Add `desc` to all keymaps in `lua/plugins/harpoon.lua`
- [ ] Add `desc` to all keymaps in `lua/plugins/dap.lua`
- [ ] Add `desc` to keymap in `lua/plugins/undotree.lua`
- [ ] Run `nvim --headless '+qa'` to verify clean parse

## Verification
- `nvim --headless '+qa'` passes
- All keymap calls have a `desc` field in their opts table
