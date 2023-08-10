return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "make", "cmake" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        cmake = {},
      },
    },
  },
}
