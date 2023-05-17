-- =================
-- init.lua
-- Note:
-- =================
--
local M = {}

M.api = {}

M.api.autocmd = vim.api.nvim_create_autocmd

function M.api.augroup(name)
  return vim.api.nvim_create_augroup("lichtvim_" .. name, { clear = true })
end

M.list = {}

function M.list.extend(l1, l2)
  for _, v in ipairs(l2) do
    l1[#l1 + 1] = v
  end
  return l1
end

M.table = {}

function M.table.merge(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" then
      if type(t1[k] or false) == "table" then
        M.table.merge(t1[k] or {}, t2[k] or {})
      else
        t1[k] = v
      end
    else
      t1[k] = v
    end
  end
  return t1
end

M.file = {}

function M.file.is_exist(file)
  return vim.fn.filereadable(file) == 1
end

function M.file.is_dir(file)
  return vim.fn.isdirectory(file) == 1
end

M.path = {}

M.path.root_patterns = { ".git", "lua" }

---@alias FileType "file"|"directory"|"link"|"fifo"|"socket"|"char"|"block"|nil
---@param path string
---@param fn fun(path: string, name:string, type:FileType):boolean?
function M.path.ls(path, fn)
  local handle = vim.loop.fs_scandir(path)
  while handle do
    local name, t = vim.loop.fs_scandir_next(handle)
    if not name then
      break
    end

    local fname = path .. "/" .. name

    if fn(fname, name, t or vim.loop.fs_stat(fname).type) == false then
      break
    end
  end
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.path.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace
          and vim.tbl_map(function(ws)
            return vim.uri_to_fname(ws.uri)
          end, workspace)
        or client.config.root_dir and { client.config.root_dir }
        or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.path.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

function M.path.git_dir()
  local git_dir = vim.fn.system(string.format("git -C %s rev-parse --show-toplevel", vim.fn.expand("%:p:h")))
  local is_git_dir = vim.fn.matchstr(git_dir, "^fatal:.*") == ""
  if not is_git_dir then
    return
  end
  return vim.trim(git_dir)
end

function M.path.join(...)
  return table.concat(vim.tbl_flatten({ ... }), "/")
end

M.hi = {}

function M.hi.set(name, opts)
  local command = "highlight " .. name
  for k, v in pairs(opts) do
    if k ~= "gui" then
      command = command .. " gui" .. k .. "=" .. v
    else
      command = command .. " " .. k .. "=" .. v
    end
  end
  vim.cmd(command)
end

function M.hi.get(group, style)
  local opts = {}
  local output = vim.fn.execute("highlight " .. group)
  local lines = vim.fn.trim(output)
  for k, v in lines:gmatch("(%a+)=(#?%w+)") do
    opts[k] = v
  end
  if style ~= "gui" then
    return opts["gui" .. style]
  end
  return opts[style]
end

M.str = {}

function M.str.first_upper(str)
  return str:sub(1, 1):upper() .. str:sub(2)
end

function M.str.starts_with(str, s)
  if #str < #s then
    return false
  end
  return str:sub(1, #s) == s
end

function M.str.ends_with(str, e)
  if #str < #e then
    return false
  end
  return str:sub(-#e) == e
end

M.sys = {}

function M.sys.IsMacOS()
  return vim.fn.has("mac")
end

function M.sys.IsLinux()
  -- return vim.fn.has("unix") and not fn.has("macunix") and not fn.has("win32unix")
  return vim.loop.os_uname().sysname() == "Linux"
end

function M.sys.IsWindows()
  -- return vim.fn.has("win16") or fn.has("win32") or fn.has("win64")
  return vim.loop.os_uname().sysname == "Windows_NT"
end

function M.sys.IsGUI()
  return vim.fn.has("gui_running")
end

function M.sys.IsNeovide()
  return vim.fn.exists("g:neovide")
end

function M.sys.IsTerm()
  return vim.fn.exists("g:termguicolors")
end

M.buf = {}

function M.buf.winid(bufnr)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == bufnr then
      return win
    end
  end
end

function M.buf.path()
  return vim.fn.expand("%")
end

function M.buf.full_path()
  return vim.fn.fnamemodify(vim.fn.expand("%"), ":p")
end

M.icons = {}

local icons = require("lichtvim.utils.ui.icons")

function M.icons.group(group)
  if not group then
    return {}
  end

  return icons[group] or {}
end

function M.icons.get(group, name)
  if not group or not name then
    return " "
  end

  return icons[group][name] or ""
end


return M
