# Remove `nvim-treesitter/playground`

## Context
`nvim-treesitter/playground` is still declared in `lua/plugins/treesitter.lua`, but there are no config references, mappings, or commands elsewhere in this repo that depend on it. Upstream marks the plugin as deprecated in favor of built-in Neovim tools such as `:Inspect`, `:InspectTree`, and `:EditQuery`. The goal is to remove the archived plugin without losing useful Treesitter inspection workflows.

## Approach
Remove the standalone `nvim-treesitter/playground` plugin spec from the Treesitter plugin list and keep the existing `nvim-treesitter` setup intact. Do not add replacement plugins. Instead, rely on Neovim built-ins for ad-hoc Treesitter inspection and query editing.

## Files to modify
- `lua/plugins/treesitter.lua`
- `CONFIG_CHECKLIST.md`

## Reuse
- Existing Treesitter setup in `lua/plugins/treesitter.lua`
- Built-in Neovim Treesitter inspection commands:
  - `:Inspect`
  - `:InspectTree`
  - `:EditQuery`

## Steps
- [ ] Remove the `nvim-treesitter/playground` plugin entry from `lua/plugins/treesitter.lua`.
- [ ] Leave the main `nvim-treesitter` spec and existing refactor settings unchanged.
- [ ] Mark the checklist item complete in `CONFIG_CHECKLIST.md` and note the built-in command replacements.
- [ ] Refresh plugins/lock state afterward with `:Lazy sync` if you want the installed checkout and lockfile updated.

## Verification
- Start Neovim headless to ensure the config still parses: `nvim --headless '+qa'`
- Confirm there are no remaining playground references in the config: search for `playground`, `TSPlayground`, and related commands.
- In an interactive session, verify the replacement workflow is available:
  - `:Inspect`
  - `:InspectTree`
  - `:EditQuery` (Neovim 0.10+)
