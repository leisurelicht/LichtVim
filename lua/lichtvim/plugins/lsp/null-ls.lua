return {
  {
    "ThePrimeagen/refactoring.nvim",
    enabled = true,
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
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
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      debug = false,
      sources = {},
    },
    config = true,
  },
}
