return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufRead", "BufNewFile" },
    cmd = { "TSInstall", "TSUpdate", "TSModuleInfo", "TSUpdateSync" },
    dependencies = {
      "p00f/nvim-ts-rainbow",
      "RRethy/nvim-treesitter-endwise",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = {
      ensure_installed = { "comment" },
      context_commentstring = { enable = true },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          node_decremental = "<BS>",
          scope_incremental = false,
        },
      },
      -- 彩虹括号
      rainbow = {
        enable = true,
        disable = {},
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        colors = {}, -- table of hex strings
        termcolors = {}, -- table of colour name strings
      },
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
