return {
  {
    "ThePrimeagen/refactoring.nvim",
    enabled = false,
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
    opts = {
      debug = false,
      sources = {},
    },
    config = true,
  },
}
