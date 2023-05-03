return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "bash" })
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "shfmt",
        -- "shellcheck",
      })
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      vim.list_extend(opts.sources, {
        null_ls.builtins.formatting.shfmt,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = {
        bashls = {
          settings = {
            document_diagnostics = true,
            document_formatting = false,
            formatting_on_save = true,
          },
          options = {
            ignoredRootPaths = { "~" },
          },
        },
      }
    end,
  },
}
