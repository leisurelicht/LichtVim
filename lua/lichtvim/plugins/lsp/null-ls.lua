return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    enabled = true,
    event = "LspAttach",
    keys = {
      { "<leader>pn", "<cmd>NullLsInfo<cr>", desc = "Null-ls info" },
    },
    opts = function()
      local null_ls = require("null-ls")
      return {
        debug = false,
        sources = {
          null_ls.builtins.completion.spell,
        },
      }
    end,
    config = true,
  },
}
