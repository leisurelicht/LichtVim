return {
  -- nightfox
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    opts = { options = { styles = { comments = "italic", keywords = "bold", types = "italic,bold" } } },
  }, -- catppuccin
  { "catppuccin/nvim", lazy = true, name = "catppuccin" },
}
