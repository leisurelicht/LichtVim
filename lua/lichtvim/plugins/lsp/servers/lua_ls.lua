return {
  settings = {
    document_diagnostics = false,
    document_formatting = false,
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
          globals = { "vim" },
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
        format = {
          enable = true,
          -- Put format options here
          -- NOTE: the value should be STRING!!
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
          },
        },
      },
    },
  },
}
