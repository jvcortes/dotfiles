# Keep `none-ls`, make linters optional, remove `vale`

## Context
You want to keep `none-ls.nvim` because you still use it as a hook point for linters, but you do **not** currently use `vale`.

Current config in `lua/plugins/none-ls.lua` always registers:
- `null_ls.builtins.completion.spell`
- `null_ls.builtins.diagnostics.vale`

That hard requirement makes health/runtime unhappy when `vale` is not installed or unavailable on `$PATH`.

## Goal
Preserve `none-ls.nvim`, but make external linter registrations optional so missing binaries fail silently.

## Approach
Build the `none-ls` source list from an explicit, user-maintained list of desired sources:
- define the sources you want to use in one local table
- for each source that depends on an external executable, only register it if `vim.fn.executable(...) == 1`
- keep non-external sources in the same declared list if you want them always enabled
- remove `vale` as a mandatory source

This keeps `none-ls` available, makes your intended linters explicit in one place, and avoids hard-failing when optional tools are absent.

## Files to modify
- `lua/plugins/none-ls.lua`
- `CONFIG_CHECKLIST.md`

## Reuse
- Existing `none-ls` plugin setup in `lua/plugins/none-ls.lua`
- Existing `null-ls` builtins API
- `vim.fn.executable()` for PATH checks

## Proposed behavior
- Keep `null_ls.setup(...)`
- Replace the fixed `sources = { ... }` table with:
  1. a declared list of desired sources
  2. a small filter/collector step that checks executables before registration
- Treat `vale` as optional instead of mandatory
- Leave room to add more optional linters later by adding them to the declared list

Example pattern:
- define something like:
  - `local desired_sources = {`
  - `  { source = null_ls.builtins.completion.spell },`
  - `  { source = null_ls.builtins.diagnostics.vale, command = "vale" },`
  - `}`
- then build the final `sources` by iterating that list and only inserting entries whose `command` is executable (or that do not declare a command)

## Steps
- [ ] Update `lua/plugins/none-ls.lua` to define a single explicit list of desired `none-ls` sources.
- [ ] Build the final registered `sources` table by filtering that declared list with PATH checks where needed.
- [ ] Remove the unconditional `vale` registration.
- [ ] Keep `none-ls` itself enabled.
- [ ] Mark the checklist item complete in `CONFIG_CHECKLIST.md` with a note that `none-ls` was kept and linters are now optional via a declared source list plus PATH checks.

## Verification
- Parse check: `nvim --headless '+qa'`
- Search check:
  - `rg -n 'vale|executable|null_ls\.builtins' lua/plugins/none-ls.lua`
- Optional runtime/health check:
  - with no `vale` on PATH, `none-ls` should still load cleanly
  - with `vale` installed later, it should automatically register again without further config changes

## Expected result
After this change:
- `none-ls.nvim` remains part of the config
- your desired linters/tools are declared explicitly in one list
- `vale` is no longer a hard dependency
- optional linters can be absent from `$PATH` without causing noisy failures
- the config becomes easier to extend with more optional external tools later by editing the declared source list
