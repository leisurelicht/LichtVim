return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    enabled = true,
    event = "LspAttach",
    opts = function()
      local null_ls = require("null-ls")
      return {
        debug = false,
        sources = {
          null_ls.builtins.completion.spell,
        },
        on_attach = function(client, bufnr)
          require("lichtvim.plugins.lsp.config.format").on_attach(client, bufnr)
        end,
      }
    end,
    config = true,
  },
}
