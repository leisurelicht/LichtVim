-- =================
-- keybindings.lua
-- Note: 快捷键设置
-- =================
local utils = require("lichtvim.utils")
local call = utils.func.call

-- normal 模式下按 esc 取消高亮显示
map.set("n", "<leader>x", ":nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>", "󰽉 Redraw")

-- better up/down
map.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", "down", { expr = true, silent = true })
map.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", "up", { expr = true, silent = true })
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map.set("n", "n", "'Nn'[v:searchforward]", "Next search result", { expr = true })
map.set("x", "n", "'Nn'[v:searchforward]", "Next search result", { expr = true })
map.set("o", "n", "'Nn'[v:searchforward]", "Next search result", { expr = true })
map.set("n", "N", "'nN'[v:searchforward]", "Prev search result", { expr = true })
map.set("x", "N", "'nN'[v:searchforward]", "Prev search result", { expr = true })
map.set("o", "N", "'nN'[v:searchforward]", "Prev search result", { expr = true })
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
-- toggle
map.set("n", "<leader>ua", utils.option.toggle_mouse, "Toggle mouse")
map.set("n", "<leader>ue", utils.option.toggle("spell"), "Toggle spell check")
map.set("n", "<leader>uw", utils.option.toggle("wrap"), "Toggle wrap")
map.set("n", "<leader>un", utils.option.toggle("number"), "Toggle number")
map.set("n", "<leader>ur", utils.option.toggle("relativenumber"), "Toggle relative number")
map.set("n", "<leader>uc", utils.option.toggle("cursorline"), "Toggle cursorline")
map.set("n", "<leader>uv", utils.option.toggle("cursorcolumn"), "Toggle cursorcolumn")
map.set("n", "<leader>uf", utils.option.toggle("foldenable"), "Toggle foldenable")
map.set("n", "<leader>ud", utils.option.toggle("foldcolumn", false, { "0", "1" }), "Toggle foldcolumn")
map.set("n", "<leader>ul", utils.option.toggle("list"), "Toggle list")
map.set("n", "<leader>uc", "<cmd>ColorizerToggle<cr>", "Toggle colorizer")
if vim.lsp.inlay_hint then
  map("n", "<leader>uh", call(vim.buf.inlay_hint, { 0, nil }), "Toggle inlay hints")
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup(utils.title.add("Keymap"), { clear = false }),
  pattern = { "*" },
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }

    map.set("n", "<leader>q", function()
      vim.ui.select({ "Yes", "No" }, {
        prompt = "Comfirm to quit?",
        telescope = require("telescope.themes").get_dropdown({
          winblend = 0,
          layout_config = { width = 0.22, height = 0.12 },
        }),
      }, function(choice)
        if choice ~= "Yes" then
          return
        end
        vim.cmd([[ wa | quitall ]])
      end)
    end, " Quit", opts)

    map.set("n", "<leader>;", function()
      call(require("notify").dismiss, { silent = true, pending = true })
      require("spectre").close()
      vim.cmd([[ Neotree close ]])
      vim.cmd([[ TroubleClose ]])
      vim.cmd([[silent wa | silent %bd | Alpha]])
    end, "󰧨 Dashboard", opts)

    -- 窗口切换组合快捷键
    map.set("n", "<C-j>", "<C-W><C-j>", "Down window", opts)
    map.set("n", "<C-k>", "<C-W><C-k>", "Up window", opts)
    map.set("n", "<C-l>", "<C-W><C-l>", "Left window", opts)
    map.set("n", "<C-h>", "<C-W><C-h>", "Right window", opts)
    -- 窗口快速跳转
    map.set("n", "<leader>1", "<cmd>1wincmd w<cr>", "Win 1", opts)
    map.set("n", "<leader>2", "<cmd>2wincmd w<cr>", "Win 2", opts)
    map.set("n", "<leader>3", "<cmd>3wincmd w<cr>", "Win 3", opts)
    map.set("n", "<leader>4", "<cmd>4wincmd w<cr>", "Win 4", opts)
    map.set("n", "<leader>5", "<cmd>5wincmd w<cr>", "Win 5", opts)
    map.set("n", "<leader>6", "<cmd>6wincmd w<cr>", "Win 6", opts)
    map.set("n", "<leader>7", "<cmd>7wincmd w<cr>", "Win 7", opts)
    map.set("n", "<leader>8", "<cmd>8wincmd w<cr>", "Win 8", opts)

    if vim.bo[event.buf].filetype == "neo-tree" then
      return
    end

    -- 行移动
    map.set("n", "<A-j>", "<cmd>m .+1<cr>==", "Move line down", opts)
    map.set("n", "<A-k>", "<cmd>m .-2<cr>==", "Move line up", opts)
    map.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", "Move line down", opts)
    map.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", "Move line up", opts)
    map.set("v", "<A-j>", ":m '>+1<cr>gv=gv", "Move line down", opts)
    map.set("v", "<A-k>", ":m '<-2<cr>gv=gv", "Move line up", opts)
    -- 连续缩进
    map.set("v", "<", "<gv", "Move left continuously", opts)
    map.set("v", ">", ">gv", "Move right continuously", opts)
    -- 分屏
    map.set("n", "<leader>wh", "<cmd>vertical leftabove sbuffer<cr>", "Left", opts)
    map.set("n", "<leader>wl", "<cmd>vertical rightbelow sbuffer<cr>", "Right", opts)
    map.set("n", "<leader>wk", "<cmd>horizontal aboveleft sbuffer<cr>", "Above", opts)
    map.set("n", "<leader>wj", "<cmd>horizontal belowright sbuffer<cr>", "Below", opts)
    map.set("n", "<leader>wy", "<cmd>vertical topleft sbuffer<cr>", "Far left", opts)
    map.set("n", "<leader>wo", "<cmd>vertical botright sbuffer<cr>", "Far right", opts)
    map.set("n", "<leader>wi", "<cmd>horizontal topleft sbuffer<cr>", "Top", opts)
    map.set("n", "<leader>wu", "<cmd>horizontal botright sbuffer<cr>", "Bottom", opts)
    map.set("n", "<leader>wd", "<C-w>c", "Close current window", opts) -- 关闭当前分屏
    map.set("n", "<leader>wc", "<C-w>o", "Close other window", opts) -- 关闭其他分屏
    -- buffer
    map.set("n", "<leader>bf", "<cmd>bfirst<cr>", "First buffer", opts)
    map.set("n", "<leader>bl", "<cmd>blast<cr>", "Last buffer", opts)
    map.set("n", "<leader>bp", "<cmd>bprev<cr>", "Previous buffer", opts)
    map.set("n", "<leader>bn", "<cmd>bnext<cr>", "Next buffer", opts)
    map.set("n", "[b", "<cmd>bprev<cr>", "Previous buffer", opts)
    map.set("n", "]b", "<cmd>bnext<cr>", "Next buffer", opts)
    map.set("n", "<leader>bs", utils.plugs.telescope("buffers"), "Buffers", opts)
    -- shortcuts
    map.set("n", "<leader>cu", "viwUe", "Upper word", opts)
    map.set("n", "<leader>cl", "viwue", "Lower word", opts)
    map.set("n", "<leader>co", "wb~ea", "Upper first word", opts)
    map.set("i", "<C-u>", "<esc>viwUea", "Upper word", opts) -- 一键大写
    map.set("i", "<C-l>", "<esc>viwuea", "Lower word", opts) -- 一键小写
    map.set("i", "<C-O>", "<ESC>wb~ea", "Upper first word", opts) -- 首字母大写
  end,
})
