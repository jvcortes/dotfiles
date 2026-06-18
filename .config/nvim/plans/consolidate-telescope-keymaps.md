# Consolidate Telescope keymaps/config

## Context
Telescope mappings are currently split across two places:

1. `lua/config/mappings/telescope.lua`
2. `lua/plugins/telescope.lua`

This causes duplication and drift:
- `lua/config/mappings/telescope.lua` defines the main mapping set
- `lua/plugins/telescope.lua` redefines overlapping keys
- `<leader>fg` is assigned twice inside the plugin config, so `git_files` is immediately overwritten by `live_grep`
- naming is inconsistent (`<leader>bb` in one place, `<leader>fb` in the other; `<leader>fs` in one place, `<leader>pf` in the other)

## Approach
Keep Telescope plugin setup in the plugin file, but move **all keymaps** to the dedicated mappings file so mappings are defined once.

Recommended direction:
- `lua/plugins/telescope.lua`
  - keep plugin loading
  - keep dependencies
  - keep `telescope-ui-select` setup and extension loading
  - remove the inline keymap definitions from the Telescope plugin spec
- `lua/config/mappings/telescope.lua`
  - remain the single source of truth for Telescope mappings
  - add any genuinely useful mappings currently only present in the plugin file, if you want to preserve them

## Mapping decision point
Before implementation, decide how to normalize the duplicated intent:
- keep the existing mappings from `lua/config/mappings/telescope.lua` as authoritative, or
- merge selected plugin-file mappings into that file

Most likely recommendation:
- keep the dedicated mappings file as authoritative
- preserve these existing keys:
  - `<leader>bb` → buffers
  - `<leader>ff` → find_files
  - `<leader>fg` → live_grep
  - `<leader>fs` → grep_string
  - `<leader>fh` → help_tags
  - `<leader>fr` → oldfiles
  - `<leader>gf` → git_files
  - `<leader>mp` → man_pages
  - `<leader>vc` → colorscheme
  - `<leader>vx` → commands
- add `<leader>pf` for prompt-based grep-string

## Files to modify
- `lua/plugins/telescope.lua`
- `lua/config/mappings/telescope.lua`
- `CONFIG_CHECKLIST.md`

## Reuse
- Existing centralized mapping file: `lua/config/mappings/telescope.lua`
- Existing Telescope plugin setup and extension loading in `lua/plugins/telescope.lua`

## Steps
- [ ] Remove inline Telescope keymaps from `lua/plugins/telescope.lua`.
- [ ] Keep `telescope-ui-select` setup/extension loading intact.
- [ ] Ensure `lua/config/mappings/telescope.lua` is the only place defining Telescope keymaps.
- [ ] If desired, merge any useful missing mapping from the plugin file into the mappings file deliberately instead of keeping duplicates.
- [ ] Mark both checklist items complete in `CONFIG_CHECKLIST.md` if this also resolves the duplicated `<leader>fg` assignment.

## Verification
- Parse check: `nvim --headless '+qa'`
- Search check:
  - `rg -n '<leader>ff|<leader>fg|<leader>fh|<leader>fs|<leader>fr|<leader>gf|<leader>bb|<leader>fb|<leader>pf' lua/config/mappings/telescope.lua lua/plugins/telescope.lua`
- Confirm duplicate `<leader>fg` assignments are gone.

## Expected result
After this cleanup:
- Telescope keymaps are defined exactly once
- the duplicated `<leader>fg` overwrite is gone
- the plugin file only handles plugin setup/extension loading
- the mappings file becomes the single source of truth for Telescope shortcuts
