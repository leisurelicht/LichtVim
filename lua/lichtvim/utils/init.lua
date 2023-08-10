-- =================
-- init.lua
-- Note:
-- =================
--
local M = {}

M.unset_keybind_filetypes = {
  "alpha",
  "neo-tree",
  "neo-tree-popup",
  "lazy",
  "mason",
  "lspinfo",
  "toggleterm",
  "null-ls-info",
  "TelescopePrompt",
}

function M.unset_keybind_buf(ft)
  return vim.fn.index(M.unset_keybind_filetypes, ft) ~= -1 and true or false
end

function M.fg(name)
  ---@type {foreground?:number}?
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
  local fg = hl and hl.fg or hl.foreground
  return fg and { fg = string.format("#%06x", fg) }
end

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

M.path.root_patterns = { ".git", "lua", "makefile" }

--- returns the root directory based on:
--- * lsp workspace folders
--- * lsp root_dir
--- * root pattern of filename of the current buffer
--- * root pattern of cwd
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
      return log.info("Set " .. option .. " to " .. vim.inspect(vim.opt_local[option]:get()), { "Option" })
    end
    vim.opt_local[option] = not vim.opt_local[option]:get()
    if not silent then
      if vim.opt_local[option]:get() then
        log.info("Enabled " .. option, { "Option" })
      else
        log.warn("Disabled " .. option, { "Option" })
      end
    end
  end
end

--- Toggle mouse mode
function M.option.toggle_mouse()
  if vim.o.mouse == "a" then
    vim.o.mouse = ""
    log.warn("Disabled mouse mode", { title = "Option" })
  else
    vim.o.mouse = "a"
    log.info("Enabled mouse mode", { title = "Option" })
  end
end

function M.option.toggle_listchars()
  if vim.o.listchars == "extends:❯,precedes:❮,tab:  " then
    vim.o.listchars = "tab:󰌒 ,eol:↴,trail:·,extends:❯,precedes:❮,nbsp:+,space:⋅"
    log.info("Enabled listchars", { title = "Option" })
  else
    vim.o.listchars = "extends:❯,precedes:❮,tab:  "
    log.warn("Disabled listchars", { title = "Option" })
  end
end

local nu = { number = true, relativenumber = true }
function M.option.toggle_number()
  if vim.opt_local.number:get() or vim.opt_local.relativenumber:get() then
    nu = { number = vim.opt_local.number:get(), relativenumber = vim.opt_local.relativenumber:get() }
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    log.warn("Disabled line numbers", { title = "Option" })
  else
    vim.opt_local.number = nu.number
    vim.opt_local.relativenumber = nu.relativenumber
    log.info("Enabled line numbers", { title = "Option" })
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

M.func = {}

function M.func.call(fn, ...)
  local args = { ... }
  return function()
    fn(unpack(args))
  end
end

M.title = {}

M.title.string = "LichtVim"

function M.title.add(body)
  if body == nil then
    return M.title.string
  end
  return string.format("%s%s", M.title.string, body)
end

return M
