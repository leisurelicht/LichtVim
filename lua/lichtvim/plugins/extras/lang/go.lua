return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "go", "gomod", "gowork", "gosum" })
      end
    end,
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
    "ThePrimeagen/refactoring.nvim",
    opts = {
      prompt_func_return_type = {
        go = true,
      },
      prompt_func_param_type = {
        go = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    ft = "go",
    opts = {
      servers = {
        gopls = {
          cmd = { "gopls" },
          settings = {
            gopls = {
              experimentalPostfixCompletions = true,
              analyses = {
                shadow = true,
                unsafeptr = true,
                unreachable = true,
                unusedresult = true,
                unusedparams = true,
              },
              staticcheck = true,
            },
          },
          init_options = {
            usePlaceholders = true,
          },
        },
      },
    },
  },
}
