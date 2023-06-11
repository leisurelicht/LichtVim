-- =================
-- init.lua
-- Note:
-- =================
--
local util = require("lazy.core.util")

local M = {}

-- M.table = {}

-- --- Merge extended options with a default table of options
-- ---@param default? table The default table that you want to merge into
-- ---@param opts? table The new options that should be merged with the default table
-- ---@return table # The merged table
-- function M.table.extend(default, opts)
--   opts = opts or {}
--   return default and vim.tbl_deep_extend("force", default, opts) or opts
-- end

M.list = {}

--- Extend a list with another list
---@param l1 table The list that you want to extend
---@param l2 table The list that you want to extend with
---@return table # The extended list
function M.list.extend(l1, l2)
  for _, v in ipairs(l2) do
    l1[#l1 + 1] = v
  end
  return l1
end

M.file = {}

--- Check if a file exists
---@param file string The file that you want to check
---@return boolean # True if the file exists, false if not
function M.file.is_exist(file)
  return vim.fn.filereadable(file) == 1
end

--- Check if a file is a directory
---@param file string The file that you want to check
---@return boolean # True if the file is a directory, false if not
function M.file.is_dir(file)
  return vim.fn.isdirectory(file) == 1
end

M.path = {}

M.path.root_patterns = { ".git", "lua" }

---@alias filetypes "string"|"file"|"directory"|"link"|"fifo"|"socket"|"char"|"block"|nil
---@param path string
---@param fn fun(path: string, name:string, type:filetypes):boolean?
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
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if r == nil then
          r = p
        end
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

--- Join path segments into a path
---@vararg string
---@return string
function M.path.join(...)
  return table.concat(vim.tbl_flatten({ ... }), "/")
end

M.git = {}

--- Get the git directory of the current buffer
---@return string?
function M.git.dir()
  local git_dir = vim.fn.system(string.format("git -C %s rev-parse --show-toplevel", vim.fn.expand("%:p:h")))
  local is_git_dir = vim.fn.matchstr(git_dir, "^fatal:.*") == ""
  if not is_git_dir then
    return
  end
  return vim.trim(git_dir)
end

--- returns is git repo
---@return boolean
function M.git.is_repo()
  local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
  if handle == nil then
    return false
  end
  local result = handle:read("*a")
  handle:close()

  if result:match("true") then
    return true
  else
    return false
  end
end

M.str = {}

--- Upper case the first character of a string
---@param str string The string that you want to upper case the first character of
---@return string # The string with the first character upper cased
function M.str.first_upper(str)
  return str:sub(1, 1):upper() .. str:sub(2)
end

--- Check if a string starts with a specific string
---@param str string The string that you want to check
---@param s string The string that you want to check if the first characters of the string match
---@return boolean # True if the string starts with the specific string, false if not
function M.str.starts_with(str, s)
  if #str < #s then
    return false
  end
  return str:sub(1, #s) == s
end

--- Check if a string ends with a specific string
---@param str string The string that you want to check
---@param e string The string that you want to check if the last characters of the string match
---@return boolean # True if the string ends with the specific string, false if not
function M.str.ends_with(str, e)
  if #str < #e then
    return false
  end
  return str:sub(-#e) == e
end

M.sys = {}

--- Check if the system is macos
---@return boolean # True if the system is macos, false if not
function M.sys.is_macos()
  return vim.fn.has("mac") == 1
end

--- Check if the system is linux
---@return boolean # True if the system is linux, false if not
function M.sys.is_linux()
  -- return vim.fn.has("unix") and not fn.has("macunix") and not fn.has("win32unix")
  return vim.loop.os_uname().sysname() == "Linux"
end

--- Check if the system is windows
---@return boolean # True if the system is windows, false if not
function M.sys.is_windows()
  -- return vim.fn.has("win16") or fn.has("win32") or fn.has("win64")
  return vim.loop.os_uname().sysname == "Windows_NT"
end

--- Check if the system is gui
---@return boolean # True if the system is gui, false if not
function M.sys.is_gui()
  return vim.fn.has("gui_running") == 1
end

--- Check if the system is neovide
---@return boolean # True if the system is neovide, false if not
function M.sys.is_neovide()
  return vim.g.neovide
end

--- Check if the system is terminal
---@return boolean # True if the system is terminal, false if not
function M.sys.is_term()
  return vim.fn.exists("g:termguicolors") == 1
end

M.buf = {}

--- Get the current buffer window number
---@return number|nil # The current buffer window number
function M.buf.winid(bufnr)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == bufnr then
      return win
    end
  end
  return nil
end

--- Get the current buffer path
---@return string # The current buffer path
function M.buf.path()
  return vim.fn.expand("%")
end

---Get the current buffer full path
---@return string # The current buffer full path
function M.buf.full_path()
  return vim.fn.fnamemodify(vim.fn.expand("%"), ":p")
end

M.win = {}

--- Get the current window number
---@return number # The current window number
function M.win.num()
  local num = vim.api.nvim_eval("winnr()")
  return "[" .. num .. "]"
end

M.option = {}

--- Set an option
---@param option string
---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.option.toggle(option, silent, values)
  return function()
    if values then
      if vim.opt_local[option]:get() == values[1] then
        vim.opt_local[option] = values[2]
      else
        vim.opt_local[option] = values[1]
      end
      return util.info("Set " .. option .. " to " .. vim.inspect(vim.opt_local[option]:get()), { title = LichtVimTitle .. "Option" })
    end
    vim.opt_local[option] = not vim.opt_local[option]:get()
    if not silent then
      if vim.opt_local[option]:get() then
        util.info("Enabled " .. option, { title = LichtVimTitle .. " Option" })
      else
        util.warn("Disabled " .. option, { title = LichtVimTitle .. " Option" })
      end
    end
  end
end

--- Toggle mouse mode
function M.option.toggle_mouse()
  if vim.o.mouse == "a" then
    vim.o.mouse = ""
    util.warn("Disabled mouse mode", { title = LichtVimTitle .. " Option" })
  else
    vim.o.mouse = "a"
    util.info("Enabled mouse mode", { title = LichtVimTitle .. " Option" })
  end
end

M.plugs = {}

--- This will return a function that calls telescope.
--- cwd will default to lazyvim.util.get_root
--- for `files`, git_files or find_files will be chosen depending on .git
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

--- Add a terminal window
function M.plugs.smart_add_terminal()
  ---@diagnostic disable-next-line: undefined-field
  if vim.b.toggle_number == nil then
    util.warn("Need to create a terminal and move in it first", { title = LichtVimTitle .. " Terminal" })
    return
  end

  local direction = require("toggleterm.ui").guess_direction()

  if direction == nil then
    if vim.g._term_direction == 1 then
      direction = "vertical"
    elseif vim.g._term_direction == 2 then
      direction = "horizontal"
    elseif vim.g._term_direction == 0 then
      util.warn("Can not add a terminal window", { title = LichtVimTitle .. " Terminal" })
      return
    end
  end

  if direction == "vertical" then
    vim.cmd("exe b:toggle_number+1.'ToggleTerm direction=vertical'")
    vim.g._term_direction = 1
  elseif direction == "horizontal" then
    vim.cmd("exe b:toggle_number+1.'ToggleTerm direction=horizontal'")
    vim.g._term_direction = 2
  end
end

M.lsp = {}

--- Go to the next or previous diagnostic
---@param next boolean # Go to the next diagnostic
---@param level string|nil # The severity of the diagnostic
---@return function # The function to call
function M.lsp.diagnostic_goto(next, level)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  local severity = level and vim.diagnostic.severity[level] or nil
  return function()
    go({ severity = severity, float = { border = "rounded" } })
  end
end

return M
