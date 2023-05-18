return {
  {
    "folke/tokyonight.nvim",
    event = "VeryLazy",
    -- opts = { style = "moon" },
  },
  { -- catppuccin
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "frappe",
    },
  },
  {
    "Mofiqul/vscode.nvim",
    event = "VeryLazy",
  },
}
