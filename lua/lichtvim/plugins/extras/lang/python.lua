return {
  {
    "nvim-lspconfig",
    opts = function(_, opts)
      table.insert(opts.servers, 1, { "pyright", "jedi_language_server" })
    end,
  },
}
