# Clean up stale Treesitter config entries

## Context
Your `nvim-treesitter` setup in `lua/plugins/treesitter.lua` still contains:
- `autopairs = { enable = true }`
- `autotag = { enable = true }`

Current findings:
- There is **no** `nvim-ts-autotag` plugin in the config.
- `nvim-ts-autotag` upstream now recommends its own `require('nvim-ts-autotag').setup(...)` flow and explicitly warns that setup through `nvim-treesitter.configs` is deprecated.
- `nvim-autopairs` exists as its own plugin in `lua/plugins/autopairs.lua`, but there is no separate TreeSitter integration config for it there.
- The Treesitter-side `autopairs` entry appears to be stale config rather than the active way your autopairs plugin is configured.
- You now want `nvim-ts-autotag` added back explicitly as its own plugin instead of leaving only the stale Treesitter module flag.

## Approach
Keep the current `nvim-treesitter` plugin, remove stale module entries, and add `nvim-ts-autotag` explicitly as its own plugin using the upstream-recommended setup path.

Recommended scope:
- remove `autotag = { enable = true }` from `lua/plugins/treesitter.lua`
- remove `autopairs = { enable = true }` from `lua/plugins/treesitter.lua`
- add a new plugin spec for `windwp/nvim-ts-autotag`
- configure autotag via `require('nvim-ts-autotag').setup(...)` or `opts = {}` in its own plugin file
- leave the rest of the Treesitter config unchanged

This keeps the change focused: stale Treesitter module flags are removed, and real autotag support is reintroduced the modern way.

## Files to modify
- `lua/plugins/treesitter.lua`
- `lua/plugins/` (new `nvim-ts-autotag` plugin spec file)
- `CONFIG_CHECKLIST.md`

## Reuse
- Existing Treesitter setup in `lua/plugins/treesitter.lua`
- Existing standalone `nvim-autopairs` plugin in `lua/plugins/autopairs.lua`
- Upstream-recommended standalone `nvim-ts-autotag` setup flow

## Decision notes
### `autotag`
This is the clearest stale entry, but it should be replaced rather than simply dropped:
- no `nvim-ts-autotag` plugin is installed yet
- the old Treesitter-module setup path is deprecated upstream
- a dedicated `nvim-ts-autotag` plugin entry restores the feature in the supported way

### `autopairs`
This likely should not live in the Treesitter module config anymore:
- `nvim-autopairs` is configured independently
- there is no evidence that the Treesitter module entry is the real active integration
- if you later want syntax-aware autopairs, that should be configured in `lua/plugins/autopairs.lua` via `nvim-autopairs` options rather than left as an inert Treesitter module flag

## Steps
- [ ] Remove the stale `autotag` entry from `lua/plugins/treesitter.lua`.
- [ ] Remove the stale `autopairs` entry from `lua/plugins/treesitter.lua`.
- [ ] Add a standalone `windwp/nvim-ts-autotag` plugin spec and configure it using its own setup path.
- [ ] Leave highlight / indent / parser installation / refactor settings untouched otherwise.
- [ ] Mark the checklist item complete in `CONFIG_CHECKLIST.md` with a note that stale Treesitter module flags were removed and autotag was re-added as its own plugin.

## Verification
- Parse check: `nvim --headless '+qa'`
- Search check:
  - `rg -n 'autotag|autopairs = \{ enable = true \}' lua/plugins/treesitter.lua`
  - `rg -n 'nvim-ts-autotag|require\("nvim-ts-autotag"\)|require\('\''nvim-ts-autotag'\''\)' lua/plugins`
- Optional runtime check:
  - confirm Treesitter still loads normally
  - confirm `nvim-autopairs` still loads on `InsertEnter`
  - confirm autotag works in a supported tag-based filetype once the relevant parser is installed

## Expected result
After this cleanup:
- Treesitter config will only contain modules that are actually configured and supported in this repo
- misleading/deprecated `autotag` and stale `autopairs` flags will be gone from the Treesitter module config
- `nvim-ts-autotag` will exist as an explicit plugin using its supported setup path
- any future syntax-aware autopairs work can be handled explicitly in the `nvim-autopairs` config
