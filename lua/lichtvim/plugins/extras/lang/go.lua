return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "go", "gomod", "gowork", "gosum" })
      -- table.insert(opts.indent.disable, "go")
    end,
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = { -- dependencies
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    init = function()
      vim.cmd([[silent! GoInstallDeps]])
    end,
    config = true,
  },
  {
    "m4xshen/smartcolumn.nvim",
    opts = {
      custom_colorcolumn = {
        ["go"] = "120",
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- "impl",
        -- "gomodifytags",
        "goimports-reviser",
      })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      vim.list_extend(opts.sources, {
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.goimports_reviser.with({
          args = { "-rm-unused", "-set-alias", "-format", "$FILENAME" },
        }),
        -- null_ls.builtins.code_actions.gomodifytags,
        -- null_ls.builtins.code_actions.impl,
        -- null_ls.builtins.code_actions.refactoring,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    ft = "go",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              semanticTokens = true,
              -- staticcheck = true,
              -- analyses = {
              --   unsafeptr = true,
              --   unreachable = true,
              --   unusedresult = true,
              --   unusedparams = true,
              -- },
            },
          },
        },
      },
      setup = {
        gopls = function(_, opts)
          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          lazy.on_attach(function(client, _)
            if client.name == "gopls" then
              if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end
          end)
          -- end workaround
          opts.settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          }
        end,
      },
    },
  },
}
