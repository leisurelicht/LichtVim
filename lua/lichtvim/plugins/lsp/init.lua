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
        enable = true,
        enable_in_insert = false,
        sign = true,
        sign_priority = 40,
        virtual_text = true,
      },
      ui = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      require("lspsaga").setup(opts)
    end,
  },
}
