return {
  settings = {
    document_diagnostics = true,
    document_formatting = true,
    formatting_on_save = false,
  },
  options = {
    -- cmd = { "lua-language-server", "--locale=zh-CN" },
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    log_level = 2,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim", "lazy" },
        },
        workspace = {
          -- library = vim.api.nvim_get_runtime_file("", true),
          library = "checkThirdParty",
        },
        telemetry = {
          enable = false,
        },
        completion = {
          callSnippet = "Replace",
        },
      },
    },
  },
}
