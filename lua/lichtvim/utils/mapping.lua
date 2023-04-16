-- =================
-- mapping.lua
-- Note:
-- =================
--
local M = {}

M.opts = { silent = true }

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

function M.mapKey(mode, lhs, rhs, opts)
  opts = check_opts(opts)
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

function M.mapcmd(lhs, rhs, opts)
  opts = check_opts(opts)
  vim.api.nvim_set_keymap("n", lhs, ":" .. rhs .. "<cr>", opts)
end

function M.mapcmdWait(lhs, rhs, opts)
  opts = check_opts(opts)
  vim.api.nvim_set_keymap("n", lhs, ":" .. rhs .. " ", opts)
end

function M.mapLua(lhs, rhs, opts)
  opts = check_opts(opts)
  vim.api.nvim_set_keymap("n", lhs, ":lua " .. rhs .. "<cr>", opts)
end

function M.mapBufKey(buf, mode, lhs, rhs, opts)
  opts = check_opts(opts)
  vim.api.nvim_buf_set_keymap(buf, mode, lhs, rhs, opts)
end

function M.mapBufLua(buf, lhs, rhs, opts)
  opts = check_opts(opts)
  vim.api.nvim_buf_set_keymap(buf, "n", lhs, ":lua " .. rhs .. "<cr>", opts)
end

return M
