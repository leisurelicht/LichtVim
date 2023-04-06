-- =================
-- shortcut.lua
-- Note: 自定义快捷方法
-- =================
--
local term_ok, terminal = pcall(require, "toggleterm.terminal")
local term = terminal.Terminal

local M = {}

function M._lazygit()
  if term_ok then
    term
      :new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = "curved", -- 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
        },
        -- function to run on opening the terminal
        on_open = function(term)
          vim.cmd("startinsert!")
          map.set("n", "q", "<CScutD>close<CR>", "Close Lazygit", { buffer = term.bufnr, silent = true })
        end,
      })
      :toggle({})
  end
end

function M._htop()
  if term_ok then
    term:new({ cmd = "htop", hidden = true, direction = "float" }):toggle({})
  end
end

function M._buf_path()
  local path = vim.fn.expand("%")
  print(path)
  return path
end

function M._project_path()
  print(vim.fn.getcwd())
  return vim.fn.getcwd()
end

function M._buf_full_path()
  local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":p")
  print(path)
  return path
end

function M.get_project_name()
  local project_path = require("project_nvim.project").get_project_root()
  local project_name = Str.split(project_path, "/")
  return project_name[#project_name]
end

return M
