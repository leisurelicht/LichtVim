-- =================
-- api.lua
-- Note:
-- =================
--
local M = {}

M.autocmd = vim.api.nvim_create_autocmd

function M.augroup(name, opts)
  if opts == nil then
    opts = { clear = true }
  end

  return vim.api.nvim_create_augroup("lichtvim_" .. name, opts)
end

return M
