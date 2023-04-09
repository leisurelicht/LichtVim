local M = {}

M.mason = {
  "stylua",
  "shfmt",
  "flake8",
  "luacheck",
  "gofumpt",
  "goimports",
}

function M.null_ls()
  local null_ls = require("null-ls")

  return {
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.diagnostics.luacheck.with({
      extra_args = { "--globals=vim" },
    }),

    null_ls.builtins.formatting.stylua.with({
      "--indent-type=Spaces",
      "--indent-width=2",
    }),
    null_ls.builtins.formatting.shfmt,
    -- null_ls.builtins.formatting.goimports,
    -- null_ls.builtins.formatting.gofumpt,

    null_ls.builtins.code_actions.refactoring,
    null_ls.builtins.completion.luasnip,
  }
end

return M
