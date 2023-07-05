return {
  { import = "lichtvim.plugins.lsp.lsp-config" },
  { import = "lichtvim.plugins.lsp.mason" },
  { import = "lichtvim.plugins.lsp.null-ls" },
  { import = "lichtvim.plugins.lsp.cmp" },
  {
    "nvimdev/lspsaga.nvim",
    enabled = true,
    event = "LspAttach",
    dependencies = {
      "neovim/nvim-lspconfig",
      { "nvim-tree/nvim-web-devicons" },
      --Please make sure you install markdown and markdown_inline parser
      {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
          if type(opts.ensure_installed) == "table" then
            vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline" })
          end
        end,
      },
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
      symbol_in_winbar = {
        enable = false,
      },
      lightbulb = {
        sign = false,
        virtual_text = false,
      },
      ui = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      require("lspsaga").setup(opts)
    end,
  },
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true
      require("lichtvim.utils.lazy").on_attach(function(client, buffer)
        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = function()
      return {
        highlight = true,
        separator = "  ",
        icons = require("lichtvim.config").icons.kinds,
        click = true,
      }
    end,
  },
}
