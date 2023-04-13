return {
  {
    "ThePrimeagen/refactoring.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    opts = {
      prompt_func_return_type = {
        go = true,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      prompt_func_param_type = {
        go = true,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      printf_statements = {},
      print_var_statements = {},
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    enabled = true,
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      return {
        debug = false,
        sources = function()
          local null_ls = require("null-ls")

          return {
            null_ls.builtins.diagnostics.flake8,
            null_ls.builtins.diagnostics.luacheck.with({
              extra_args = { "--globals=vim" },
            }),

            null_ls.builtins.formatting.stylua.with({
              "--indent-type=Spaces",
              "--indent-width=2",
            }),
            null_ls.builtins.formatting.shfmt,
            -- null_ls.builtins.formatting.goimports,
            -- null_ls.builtins.formatting.gofumpt,

            null_ls.builtins.code_actions.refactoring,
            null_ls.builtins.completion.luasnip,
          }
        end,
      }
    end,
  },
}
