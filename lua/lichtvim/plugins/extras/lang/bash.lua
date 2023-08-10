return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "bash" })
    end,
  },
  {
    "m4xshen/smartcolumn.nvim",
    optional = true,
    opts = { custom_colorcolumn = { ["bash"] = "120" } },
  },

  {
    "williamboman/mason.nvim",
    optional = true,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "shfmt",
      })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local null_ls = require("null-ls")
      vim.list_extend(opts.sources, {
        null_ls.builtins.formatting.shfmt,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        bashls = {
          ignoredRootPaths = { "~" },
        },
      },
    },
  },
}
