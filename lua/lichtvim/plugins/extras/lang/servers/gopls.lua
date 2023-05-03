return {
  settings = {
    document_diagnostics = true,
    document_formatting = true,
    formatting_on_save = false,
  },
  options = {
    cmd = { "gopls" },
    settings = {
      gopls = {
        experimentalPostfixCompletions = true,
        analyses = {
          unusedparams = true,
          shadow = true,
        },
        staticcheck = true,
      },
    },
    init_options = {
      usePlaceholders = true,
    },
  },
}
