return {
  -- nightfox
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    opts = { options = { styles = { comments = "italic", keywords = "bold", types = "italic,bold" } } },
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
  },
  { -- catppuccin
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
  },
}
