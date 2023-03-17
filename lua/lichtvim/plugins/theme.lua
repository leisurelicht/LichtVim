return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {style = "moon"}
  },
  -- nightfox
  {
    "EdenEast/nightfox.nvim",
    opts = {
      options = {
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic,bold"
        }
      }
    }
  },
  -- catppuccin
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin"
  }
}
