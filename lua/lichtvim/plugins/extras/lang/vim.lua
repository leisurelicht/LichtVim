return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "vim", "vimdoc" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = {
        vimls = {
          settings = {
            document_diagnostics = true,
            document_formatting = false,
            formatting_on_save = false,
          },
          options = {
            cmd = { "vim-language-server", "--stdio" },
            filetypes = { "vim" },
          },
        },
      }
    end,
  },
}
