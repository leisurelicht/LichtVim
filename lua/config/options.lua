-- Options are automatically loaded before lazy.nvim startup
-- Add any additional options here

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Python host prog: prefer pyenv neovim env, fallback to system python3
local pyenv_neovim = vim.fn.expand("$HOME/.pyenv/versions/3.12.3/envs/neovim/bin/python")
if vim.fn.filereadable(pyenv_neovim) == 1 then
  vim.g.python3_host_prog = pyenv_neovim
else
  local system_python = vim.fn.exepath("python3")
  if system_python ~= "" then
    vim.g.python3_host_prog = system_python
  end
end
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.trouble_lualine = false
-- vim.g.lazyvim_statuscolumn = {
--   folds_open = true, -- show fold sign when fold is open
--   folds_githl = true, -- highlight fold sign with git sign color
-- }

vim.opt.relativenumber = false
vim.opt.guifont = "Hack Nerd Font" -- set gui font
vim.opt.list = true -- 显示特殊字符
vim.opt.listchars = { tab = "  ", extends = "❯", precedes = "❮" } -- 字符转换

-- autoformat
vim.g.autoformat = false
