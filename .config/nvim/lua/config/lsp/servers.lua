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
          cmd = { "uv", "run", "basedpyright-langserver", "--stdio" },
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
    }
  },
  typescript = {
    use = 'vtsls',
    servers = {
      {
        name = 'vtsls',
        config = {
          settings = {
            vtsls = {
              autoUseWorkspaceTsdk = true,
            },
            typescript = {
              tsserver = {
                maxTsServerMemory = 4096,
              },
            },
          },
        },
      },
      {
        name = 'ts_ls',
        config = {},
      },
      {
        name = 'tsgo',
        config = {},
      },
    },
  },
}
