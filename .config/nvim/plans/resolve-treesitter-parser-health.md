# Resolve Treesitter parser health errors

## Context
`checkhealth vim.treesitter` currently reports parser load errors for:
- `bicep`
- `jsdoc`
- `properties`

Current findings:
- these parser binaries exist under `~/.local/share/nvim/lazy/nvim-treesitter/parser/`
- none of them are listed in your configured `ensure_installed` set in `lua/plugins/treesitter.lua`
- there are no config references to these languages elsewhere in the repo
- the errors are loader failures (`undefined symbol ... external_scanner_create`), which strongly suggests stale/incompatible parser artifacts rather than an active config issue

## Likely root cause
These are probably old parser `.so` files left over from earlier installs. Since they are not part of your current managed parser set, health still sees them, but Neovim cannot load them correctly.

## Approach
Use the smallest cleanup that matches your current config:
- treat `bicep`, `jsdoc`, and `properties` as stale parser artifacts
- uninstall/remove those specific parsers
- keep your current `ensure_installed` list unchanged
- rerun/update managed Treesitter parsers afterward

If you later need any of those languages, reinstall them explicitly and optionally add them to `ensure_installed`.

## Files / state to modify
- parser install state under `~/.local/share/nvim/lazy/nvim-treesitter/parser/`
- possibly `CONFIG_CHECKLIST.md`
- no repo source changes are necessarily required unless you decide to manage one of those parsers intentionally

## Reuse
- existing Treesitter config in `lua/plugins/treesitter.lua`
- Treesitter management commands already available:
  - `:TSUninstall`
  - `:TSUpdate`
  - `:TSInstall`

## Steps
- [ ] Remove/uninstall the stale `bicep`, `jsdoc`, and `properties` parsers.
- [ ] Rerun `:TSUpdate` for the parsers you actually manage.
- [ ] Re-run `:checkhealth vim.treesitter` to confirm those parser load errors are gone.
- [ ] Mark the checklist item complete in `CONFIG_CHECKLIST.md`.

## Verification
- `nvim --headless '+checkhealth vim.treesitter' ...`
- confirm no remaining `ERROR Parser "bicep"`, `"jsdoc"`, or `"properties"`
- confirm your configured parsers (`python`, `markdown`, `json`, `sql`, `xml`) still load normally

## If you later need one of these languages
Add it intentionally instead of relying on stale artifacts:
- temporarily: `:TSInstall bicep` (or `jsdoc`, `properties`)
- permanently: add it to `ensure_installed` in `lua/plugins/treesitter.lua`

## Expected result
After this cleanup:
- Treesitter health errors for `bicep`, `jsdoc`, and `properties` should disappear
- your parser set will better match your actual managed config
- no unrelated Treesitter behavior should change
