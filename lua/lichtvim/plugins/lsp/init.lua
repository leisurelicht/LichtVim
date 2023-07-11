return {
  { import = "lichtvim.plugins.lsp.cmp" },
  { import = "lichtvim.plugins.lsp.mason" },
  { import = "lichtvim.plugins.lsp.null-ls" },
  { import = "lichtvim.plugins.lsp.lsp-config" },
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
