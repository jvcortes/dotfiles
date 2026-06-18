# Consolidate Alpha dashboard setup

## Context
Alpha is currently configured in two competing places:

1. `init.lua` directly requires `config.dashboard`
2. `lua/plugins/dashboard.lua` also configures `goolord/alpha-nvim` with `alpha.themes.theta`

Meanwhile, `lua/config/dashboard.lua` builds a custom `alpha.themes.dashboard` layout with:
- custom ASCII logo
- randomized header highlight
- custom buttons
- custom footer
- a `FileType alpha` autocmd

So the current state is duplicated and internally inconsistent:
- one path configures `dashboard`
- the other path configures `theta`
- both call `alpha.setup(...)`

## Approach
Keep a single source of truth for Alpha and make plugin loading/configuration consistent with Lazy.

Recommended direction:
- keep the richer custom dashboard in `lua/config/dashboard.lua`
- stop initializing Alpha from `init.lua`
- make `lua/plugins/dashboard.lua` delegate to `require("config.dashboard")`
- ensure Alpha is configured exactly once

This preserves your existing custom dashboard UI while removing duplicate setup logic.

## Files to modify
- `init.lua`
- `lua/plugins/dashboard.lua`
- `lua/config/dashboard.lua` (only if a small adjustment is needed)
- `CONFIG_CHECKLIST.md`

## Reuse
- Existing custom Alpha setup in `lua/config/dashboard.lua`
- Existing plugin declaration in `lua/plugins/dashboard.lua`

## Why this direction
- `lua/config/dashboard.lua` is clearly the real intended dashboard design
- the plugin file’s `theta` setup is much more generic and would discard your custom logo/buttons/footer
- letting the plugin spec call the config is the cleaner Lazy-managed lifecycle

## Steps
- [ ] Remove the direct `require("config.dashboard")` call from `init.lua`.
- [ ] Update `lua/plugins/dashboard.lua` so the Alpha plugin loads your custom dashboard config instead of `alpha.themes.theta`.
- [ ] Keep `lua/config/dashboard.lua` as the single Alpha setup entrypoint unless a small cleanup is needed.
- [ ] Mark the checklist item complete in `CONFIG_CHECKLIST.md` with a note that Alpha now has a single source of truth.

## Verification
- Parse check: `nvim --headless '+qa'`
- Search check:
  - `rg -n 'config.dashboard|alpha\.setup|alpha\.themes\.theta' init.lua lua/config/dashboard.lua lua/plugins/dashboard.lua`
- Optional runtime check:
  - start Neovim with no file argument and confirm the custom dashboard appears
  - confirm the custom logo/buttons/footer still show

## Expected result
After this cleanup:
- Alpha is initialized once
- your custom dashboard remains intact
- the generic `theta` setup is removed
- dashboard setup becomes consistent with the rest of your Lazy-managed plugin config
