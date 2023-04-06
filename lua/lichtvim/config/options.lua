-- =================
-- options.lua
-- Note: neovim 基础设置
-- =================
--
local sys = require("lichtvim.utils").sys

if sys.IsMacOS() then
  vim.api.nvim_set_var("python3_host_prog", "/opt/homebrew/bin/python3")
elseif sys.IsLinux() then
  vim.api.nvim_set_var("python3_host_prog", "python3")
end

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

vim.g.mapleader = " "
vim.g.maplocalleader = ","

local opt = vim.opt

-- utf8
opt.mouse:append("a") -- 开启鼠标控制
opt.clipboard:append("unnamedplus") -- 系统剪贴板
opt.autowrite = true -- 自动写入
opt.confirm = true -- 确认写入
opt.number = true -- 显示行号
opt.backup = false -- 关闭自动备份
opt.writebackup = false -- 关闭自动备份
opt.swapfile = false -- 关闭交换文件
opt.grepprg = "rg --vimgrep"
opt.scrolloff = 5 -- 光标移动到buffer顶部和底部时保持5行距离
opt.wrap = false -- 不自动换行显示
opt.sidescrolloff = 8 -- 光标移动到buffer左边和右边时保持8列距离
opt.list = true -- 不可见字符不显示
opt.updatetime = 100 -- 设定在无操作时，交换文件刷写到磁盘的等待毫秒数（默认为 4000）
opt.timeoutlen = 500 -- mapping delays
opt.linebreak = true -- 不在单词中间折行
opt.inccommand = "split" -- 即时预览命令效果
opt.splitbelow = true -- 分隔窗口在当前窗口下边
opt.splitright = true -- 分隔窗口在当前窗口下边
opt.visualbell = false -- 警告时不要闪烁
opt.ignorecase = true -- 搜索时忽略大小写
opt.smartcase = true -- 搜索时只在全小写时忽略大小写
opt.autoindent = true -- 自动套用上一行的缩进方式
opt.smartindent = true -- 智能缩进
opt.expandtab = true -- Use spaces instead of tabs
opt.tabstop = 4 -- 将tab换为4个空格
opt.softtabstop = 4 --
opt.shiftwidth = 4 --
opt.shiftround = true -- 缩进取整为shiftwidth的倍数
opt.smarttab = true -- 智能tab
opt.foldmethod = "syntax" -- 折叠方式
opt.foldlevelstart = 99 -- 没有折叠
opt.spell = true -- 是否开启单词拼写检查
opt.spelllang = "en_us,cjk" -- 设定单词拼写检查的语言
opt.spelloptions = "camel"
opt.whichwrap = "b,s,<,>,[,],h,l" -- 行结尾可以跳到下一行
opt.showcmd = true -- 右下角显示正在输入的命令
opt.showtabline = 2 -- always show tabline
opt.completeopt = "menu,menuone,noselect,noinsert" -- 自动补全不自动选中
opt.wildmenu = true -- 补全增强
opt.wildmode = "longest:full"
opt.termguicolors = true -- 样式
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10
opt.shortmess:append({ S = true, W = true, I = true, c = true }) -- 信息显示控制
opt.cursorline = true -- 高亮所在行
opt.guifont = "Hack Nerd Font" -- set gui font

if vim.g.neovide then
  vim.g.neovide_cursor_vfx_mode = "railgun"
  vim.g.neovide_confirm_quit = true
  vim.g.neovide_fullscreen = true
end

opt.listchars = { tab = "▸ ", nbsp = "␣", extends = "❯", precedes = "❮", space = " ", eol = " " } -- 字符转换
