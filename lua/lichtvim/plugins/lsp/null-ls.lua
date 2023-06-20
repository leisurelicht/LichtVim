return {
  {
    "ThePrimeagen/refactoring.nvim",
    enabled = true,
    event = "LspAttach",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    opts = {
      prompt_func_return_type = {},
      prompt_func_param_type = {},
      printf_statements = {},
      print_var_statements = {},
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    enabled = true,
    event = "LspAttach",
    opts = function()
      local null_ls = require("null-ls")
      return {
        debug = false,
        sources = {
          null_ls.builtins.completion.spell,
          null_ls.builtins.code_actions.gitsigns,
        },
        on_attach = function(client, bufnr)
          require("lichtvim.plugins.lsp.config.format").on_attach(client, bufnr)
        end,
      }
    end,
    config = true,
  },
}
