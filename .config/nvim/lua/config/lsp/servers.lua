return {
  lua = {
    use = 'lua_ls',
    servers = {
      {
        name = 'lua_ls',
        config = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = {
              globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
            }
          }
        }
      }
    }
  },
  python = {
    use = 'basedpyright',
    servers = {
      {
        name = 'basedpyright',
        config = {
          settings = {
            basedpyright = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'openFilesOnly',
                useLibraryCodeForTypes = true
              },
            }
          }
        }
      },
      {
        name = 'pylsp',
        config = {}
      },
      {
        name = 'pyls',
        config = {
          settings = {
            pyls = {
              plugins = {
                pycodestyle = {
                  enabled = true
                },
              }
            }
          }
        }
      },
    }
  }
}
