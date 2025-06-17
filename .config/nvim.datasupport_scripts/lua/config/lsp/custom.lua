local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')

if not configs.pyls then
  configs.pyls = {
    default_config = {
      cmd = { 'pyls' },
      root_dir = lspconfig.util.root_pattern('.git'),
      filetypes = { 'python' },
      config = {
        pyls = {
          plugins = {
            pylint = {
              enabled = true
            }
          }
        }
      }
    }
  }
end
