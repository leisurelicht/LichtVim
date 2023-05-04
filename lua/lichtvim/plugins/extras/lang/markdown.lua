return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        zk = {
          settings = {
            document_diagnostics = true,
            document_formatting = true,
            formatting_on_save = false,
          },
          options = {
            cmd = { "zk", "lsp" },
            filetypes = { "markdown" },
          },
        },
        prosemd_lsp = {
          settings = {
            document_diagnostics = true,
            document_formatting = true,
            formatting_on_save = true,
          },
          options = {
            cmd = { "prosemd-lsp", "--stdio" },
            filetypes = { "markdown" },
            -- root_dir = function(fname)
            -- 	return lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
            -- end,
            settings = {},
          },
        },
      }
    }
  },
}
