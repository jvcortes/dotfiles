return {
  'nvim-orgmode/orgmode',
  enable = false,
  event = 'VeryLazy',
  ft = { 'org' },
  config = function()
    -- Setup orgmode
    require('orgmode').setup({
      org_agenda_files = '~/notes/*/**',
      org_default_notes_file = '~/orgfiles/refile.org',
      mappings = {
        org = {
          org_next_visible_heading = false,
          org_previous_visible_heading = false,
        }
      },
      org_hide_emphasis_markers = true,
      org_startup_indented = true,
      org_adapt_indentation = false
    })
  end,
}
