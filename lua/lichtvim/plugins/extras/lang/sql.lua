return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "sql" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = {
        sqlls = {
          settings = {
            document_diagnostics = true,
            document_formatting = true,
            formatting_on_save = true,
          },
          options = {},
        },
      }
    end,
  },
}
