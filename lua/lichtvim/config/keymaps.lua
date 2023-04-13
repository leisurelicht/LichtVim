-- =================
-- keybindings.lua
-- Note: 基础快捷键绑定设置
-- =================
--
-- 强制保存
map.set("c", "w!!", "w !sudo tee > /dev/null %", "saved")

-- 一键大写
map.set("i", "<C-u>", "<esc>viwUea", "Upper word")
-- 一键小写
map.set("i", "<C-l>", "<esc>viwuea", "Lower word")
-- 首字母大写
map.set("i", "<C-O>", "<ESC>wb~ea")

-- normal 模式下按 esc 取消高亮显示
map.set("n", "<esc>", function()
  vim.cmd("silent! noh")
end, "No highlight")

-- 窗口切换组合快捷键
map.set("n", "<C-j>", "<C-W><C-j>", "Down window")
map.set("n", "<C-k>", "<C-W><C-k>", "Up window")
map.set("n", "<C-l>", "<C-W><C-l>", "Left window")
map.set("n", "<C-h>", "<C-W><C-h>", "Right window")

map.set("v", "J", ":m '>+1<cr>gv=gv", "Move line down")
map.set("v", "K", ":m '<-2<cr>gv=gv", "Move line up")

-- 连续缩进
map.set("v", "<", "<gv", "Move left continuously")
map.set("v", ">", ">gv", "Move right continuously")

-- 分屏
-- map.set("n", "<leader>v", "<cmd>vsp<cr>", "Vsplit")
-- map.set("n", "<leader>s", "<cmd>sp<cr>", "Split")
map.set("n", "<leader>sh", "<cmd>vertical leftabove sbuffer<cr>", "Left")
map.set("n", "<leader>sl", "<cmd>vertical rightbelow sbuffer<cr>", "Right")
map.set("n", "<leader>sk", "<cmd>horizontal aboveleft sbuffer<cr>", "Above")
map.set("n", "<leader>sj", "<cmd>horizontal belowright sbuffer<cr>", "Below")

map.set("n", "<leader>si", "<cmd>vertical topleft sbuffer<cr>", "Far left")
map.set("n", "<leader>su", "<cmd>vertical botright sbuffer<cr>", "Far right")
map.set("n", "<leader>sy", "<cmd>horizontal topleft sbuffer<cr>", "Top")
map.set("n", "<leader>so", "<cmd>horizontal botright sbuffer<cr>", "Bottom")

map.set("n", "<leader>sd", "<C-w>c", "Close current window") -- 关闭当前分屏
map.set("n", "<leader>sc", "<C-w>o", "Close other window") -- 关闭其他分屏

-- 窗口快速跳转
map.set("n", "<leader>1", "<cmd>1wincmd w<cr>", "Win 1")
map.set("n", "<leader>2", "<cmd>2wincmd w<cr>", "Win 2")
map.set("n", "<leader>3", "<cmd>3wincmd w<cr>", "Win 3")
map.set("n", "<leader>4", "<cmd>4wincmd w<cr>", "Win 4")
map.set("n", "<leader>5", "<cmd>5wincmd w<cr>", "Win 5")
map.set("n", "<leader>6", "<cmd>6wincmd w<cr>", "Win 6")
map.set("n", "<leader>7", "<cmd>7wincmd w<cr>", "Win 7")
map.set("n", "<leader>8", "<cmd>8wincmd w<cr>", "Win 8")
map.set("n", "<leader>9", "<cmd>9wincmd w<cr>", "Win 9")

-- tab页
map.set("n", "<leader>te", "<cmd>tab sb<cr>", "Copy current tab")
map.set("n", "<leader>ta", "<cmd>tabnew<cr>", "New tab")
map.set("n", "<leader>tc", "<cmd>tabclose<cr>", "Close tab")
map.set("n", "<leader>tf", "<cmd>tabfirst<cr>", "First tab")
map.set("n", "<leader>tl", "<cmd>tablast<cr>", "Last tab")
map.set("n", "[t", "<cmd>tabp<cr>", "Previous tab")
map.set("n", "]t", "<cmd>tabn<cr>", "Next tab")
map.set("n", "<leader>tp", "<cmd>tabp<cr>", "Previous tab")
map.set("n", "<leader>tn", "<cmd>tabn<cr>", "Next tab")
map.set("n", "<leader>tP", "<cmd>-tabmove<cr>", "Move forward")
map.set("n", "<leader>tN", "<cmd>+tabmove<cr>", "Move backward")
-- map.set("n", "<leader>ts", "<cmd>tabs<cr>", "Show tabs")
-- map.set("n", "<leader>ts", ":tab split ", "Split Tab")

if lazy.has("tabby.nvim") then
  map.set("n", "<leader>tr", ":TabRename ", "Rename tab")
end

-- 关闭tab页
map.set("n", "<leader>too", "<cmd>tabonly<cr>", "Close all")
map.set("n", "<leader>to1", "<cmd>tabonly 1<cr>", "Close all except 1")
map.set("n", "<leader>to2", "<cmd>tabonly 2<cr>", "Close all except 2")
map.set("n", "<leader>to3", "<cmd>tabonly 3<cr>", "Close all except 3")
map.set("n", "<leader>to4", "<cmd>tabonly 4<cr>", "Close all except 4")
map.set("n", "<leader>to5", "<cmd>tabonly 5<cr>", "Close all except 5")
map.set("n", "<leader>to6", "<cmd>tabonly 6<cr>", "Close all except 6")
map.set("n", "<leader>to7", "<cmd>tabonly 7<cr>", "Close all except 7")
map.set("n", "<leader>to8", "<cmd>tabonly 8<cr>", "Close all except 8")
map.set("n", "<leader>to9", "<cmd>tabonly 9<cr>", "Close all except 9")
map.set("n", "<leader>to$", "<cmd>tabonly $<cr>", "Close all except Last")
-- tab页快速切换
map.set("n", "<leader>t1", "1gt", "Tab 1")
map.set("n", "<leader>t2", "2gt", "Tab 2")
map.set("n", "<leader>t3", "3gt", "Tab 3")
map.set("n", "<leader>t4", "4gt", "Tab 4")
map.set("n", "<leader>t5", "5gt", "Tab 5")
map.set("n", "<leader>t6", "6gt", "Tab 6")
map.set("n", "<leader>t7", "7gt", "Tab 7")
map.set("n", "<leader>t8", "8gt", "Tab 8")
map.set("n", "<leader>t9", "9gt", "Tab 9")

-- buffer
if lazy.has("flybuf.nvim") then
  map.set("n", "<leader>bs", "<cmd>FlyBuf<cr>", "Buffers")
elseif lazy.has("telescope.nvim") then
  map.set("n", "<leader>bs", require("telescope.builtin").buffers, "Buffers")
else
  map.set("n", "<leader>bs", "<cmd>buffers<cr>", "Buffers")
end

-- map.set("n", "<leader>bh ", "<cmd>ball<cr>", "Horizontally list all")
-- map.set("n", "<leader>bv", "<cmd>vertical ball<cr>", "Vertically list all")
map.set("n", "<leader>bf", "<cmd>bfirst<cr>", "First buffer")
map.set("n", "<leader>bl", "<cmd>blast<cr>", "Last buffer")
map.set("n", "<leader>bp", "<cmd>bprev<cr>", "Previous buffer")
map.set("n", "<leader>bn", "<cmd>bnext<cr>", "Next buffer")
map.set("n", "<leader>bd", "<cmd>bd<cr>", "Delete buffer")
map.set("n", "[b", "<cmd>bprev<cr>", "Previous buffer")
map.set("n", "]b", "<cmd>bnext<cr>", "Next buffer")

map.set("n", "<leader>cl", "viwue", "Lower word")
map.set("n", "<leader>cu", "viwUe", "Upper word")
map.set("n", "<leader>co", "wb~ea", "Upper first word")

-- 切换 mouse 模式
local function switch_mouse()
  if vim.opt.mouse == "" then
    vim.opt.mouse = "a"
  else
    vim.opt.mouse = ""
  end
end

map.set("n", "<leader>a", switch_mouse, "Switch mouse mode")

if lazy.has("which-key.nvim") then
  require("which-key").register({
    c = { name = "ShortCuts" },
    b = { name = "Buffer" },
    s = { name = "Split" },
    t = { name = "Tab" },
    to = { name = "Close Only" },
    mode = "n",
    prefix = "<leader>",
  })
end
