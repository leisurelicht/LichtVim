-- =================
-- mapping.lua
-- Note:
-- =================
--
local M = {}

M.opts = { noremap = true, silent = true }

local function check_opts(opts)
  if opts == nil then
    opts = M.opts
  elseif next(opts) == nil then
    opts = {}
  else
    opts = vim.tbl_extend("force", M.opts, opts)
  end
  return opts
end

function M.set(mode, lhs, rhs, desc, opts)
  opts = check_opts(opts)
  if desc ~= nil then
    opts.desc = desc
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

function M.del(mode, lhs, opts)
  vim.keymap.del(mode, lhs, opts)
end

function M.has(mode, lhs, opts)
  local keymap = {}
  if opts and opts.buffer then
    keymap = vim.api.nvim_buf_get_keymap(opts.buffer, mode)
  else
    keymap = vim.api.nvim_get_keymap(mode)
  end
  for _, v in pairs(keymap) do
    if v.lhs == lhs then
      return true
    end
  end
  return false
end

return M
