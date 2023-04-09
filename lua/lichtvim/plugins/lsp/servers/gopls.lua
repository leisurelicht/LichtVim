-- local wk = require("which-key")
local util = require("lspconfig.util")

return {
  settings = {
    document_diagnostics = true,
    document_formatting = true,
    formatting_on_save = false,
  },
  options = {
    cmd = { "gopls" },
    single_file_support = true,
    filetypes = { "go", "gomod", "gotmpl" },
    root_dir = function(fname)
      return util.root_pattern("go.work")(fname) or util.root_pattern("go.mod", ".git")(fname)
    end,
  },
}
