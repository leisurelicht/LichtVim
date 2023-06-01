-- =================
-- init.lua
-- Note:
-- =================
--
local Util = require("lazy.core.util")

local M = {}

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

--- Merge extended options with a default table of options
---@param default? table The default table that you want to merge into
---@param opts? table The new options that should be merged with the default table
---@return table # The merged table
function M.table.extend(default, opts)
  opts = opts or {}
  return default and vim.tbl_deep_extend("force", default, opts) or opts
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

function M.path.join(...)
  return table.concat(vim.tbl_flatten({ ... }), "/")
end

M.git = {}

function M.git.dir()
  local git_dir = vim.fn.system(string.format("git -C %s rev-parse --show-toplevel", vim.fn.expand("%:p:h")))
  local is_git_dir = vim.fn.matchstr(git_dir, "^fatal:.*") == ""
  if not is_git_dir then
    return
  end
  return vim.trim(git_dir)
end

-- returns is git repo
---@return bool
function M.git.is_repo()
  local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
  local result = handle:read("*a")
  handle:close()

  if result:match("true") then
    return true
  else
    return false
  end
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

function M.sys.is_macos()
  return vim.fn.has("mac")
end

function M.sys.is_linux()
  -- return vim.fn.has("unix") and not fn.has("macunix") and not fn.has("win32unix")
  return vim.loop.os_uname().sysname() == "Linux"
end

function M.sys.is_windows()
  -- return vim.fn.has("win16") or fn.has("win32") or fn.has("win64")
  return vim.loop.os_uname().sysname == "Windows_NT"
end

function M.sys.is_gui()
  return vim.fn.has("gui_running")
end

function M.sys.is_neovide()
  return vim.g.neovide
end

function M.sys.is_term()
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

M.win = {}

function M.win.num()
  -- local num = vim.inspect([[%{tabpagewinnr(tabpagenr())}]])
  -- local num = [[%{winnr()}]]

  local num = vim.api.nvim_eval("winnr()")
  return "[" .. num .. "]"
end

M.option = {}

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.option.toggle(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
    return Util.info(
      "Set " .. option .. " to " .. vim.inspect(vim.opt_local[option]:get()),
      { title = LichtVimTitle .. "Option" }
    )
  end
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    if vim.opt_local[option]:get() then
      Util.info("Enabled " .. option, { title = LichtVimTitle .. " Option" })
    else
      Util.warn("Disabled " .. option, { title = LichtVimTitle .. " Option" })
    end
  end
end

M.plugs = {}

-- this will return a function that calls telescope.
-- cwd will default to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.plugs.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = M.path.get_root() }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    require("telescope.builtin")[builtin](opts)
  end
end

M.lsp = {}

function M.lsp.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

return M
