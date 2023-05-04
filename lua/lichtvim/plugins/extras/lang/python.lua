return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "python", "htmldjango" })
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "flake8",
      })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      vim.list_extend(opts.sources, {
        null_ls.builtins.diagnostics.flake8,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local function filter_publish_diagnostics(a, params, client_id, c, config)
        local new_index = 1

        ---@diagnostic disable-next-line: redundant-parameter
        for _, diagnostic in ipairs(params.diagnostics) do
          if not vim.tbl_contains(c.filter_keywrod, diagnostic.message) then
            params.diagnostics[new_index] = diagnostic
            new_index = new_index + 1
          end
        end

        for i = new_index, #params.diagnostics do
          params.diagnostics[i] = nil
        end

        ---@diagnostic disable-next-line: redundant-parameter
        vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
      end

      vim.tbl_extend("force", opts.servers, {
        pyright = {
          settings = {
            document_diagnostics = true,
            document_formatting = false,
            formatting_on_save = false,
          },
          options = {
            handlers = {
              -- If you want to disable pyright from diagnosing unused parameters, turn on the function below
              ["textDocument/publishDiagnostics"] = vim.lsp.with(filter_publish_diagnostics, {
                filter_keywrod = {
                  '"kwargs" is not accessed',
                  '"args" is not accessed',
                },
              }),
            },
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = "basic", -- off, basic, strict
                  useLibraryCodeForTypes = true,
                  autoImportCompletions = true,
                  diagnosticMode = "workspace",
                  diagnosticSeverityOverrides = {
                    strictListInference = true,
                    strictDictionaryInference = true,
                    strictSetInference = true,
                    strictParameterNoneValue = true,
                    reportUndefinedVariable = "error",
                    reportMissingTypeStubs = "none",
                    reportIncompleteStub = "none",
                    reportInvalidStubStatement = "none",
                  },
                },
              },
            },
          },
        },
        jedi_language_server = {
          settings = {
            document_diagnostics = false,
            document_formatting = false,
            formatting_on_save = false,
          },
          options = {},
        },
      })
    end,
  },
}
