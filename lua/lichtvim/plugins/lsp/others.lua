return {
  {
    "aznhe21/actions-preview.nvim",
    enabled = true,
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("actions-preview").setup({
        diff = {
          algorithm = "patience",
          ignore_whitespace = true,
        },
        telescope = require("telescope.themes").get_dropdown({ winblend = 10 }),
      })
    end,
  },
  {
    "nvimdev/lspsaga.nvim",
    enabled = true,
    event = "LspAttach",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    opts = {
      code_action = {
        num_shortcut = true,
        show_server_name = true,
        extend_gitsigns = false,
        keys = {
          quit = "q",
          exec = "<CR>",
        },
      },
      lightbulb = {
        enable = true,
        enable_in_insert = false,
        sign = true,
        sign_priority = 40,
        virtual_text = false,
      },
      ui = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      require("lspsaga").setup(opts)
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      --Please make sure you install markdown and markdown_inline parser
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  {
    "j-hui/fidget.nvim",
    enabled = function()
      return vim.g.neovide
    end,
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("fidget").setup({
        window = { blend = 0 },
      })
    end,
  },
  {
    "simrat39/symbols-outline.nvim",
    enabled = true,
    cmd = "SymbolsOutline",
    event = "LspAttach",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    opts = { show_numbers = true },
  },
}
