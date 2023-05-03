return {
  {
    "nvim-lspconfig",
    opts = function(_, opts)
      table.insert(opts.servers, 1, { "lua_ls" })
    end,
  },
}
