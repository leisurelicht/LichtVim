return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufRead", "BufNewFile" },
    cmd = { "TSModuleInfo", "TSUpdateSync" },
    dependencies = {
      "RRethy/nvim-treesitter-endwise",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = {
      ensure_installed = { "comment" },
      ignore_install = {},
      highlight = {
        enable = true,
        disable = {},
      },
      indent = {
        enable = true,
        disable = {},
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          node_decremental = "<BS>",
          scope_incremental = false,
        },
      },
      context_commentstring = { enable = true },
      -- match % g% [% ]% z%
      matchup = { enable = true },
      endwise = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      require("nvim-treesitter.install").prefer_git = true
    end,
  },
}
