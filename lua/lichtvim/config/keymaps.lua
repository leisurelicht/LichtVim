-- =================
-- keybindings.lua
-- Note: 快捷键设置
-- =================
local option = utils.option
local wk_ok, wk = pcall(require, "which-key")

if wk_ok then
  wk.register({
    r = { name = " Projects" },
    f = { name = "󰛔 Find & Replace" },
    o = { name = " Terminal" },
    t = { name = "󱏈 Tab" },
    to = { name = "Close Only" },
    u = { name = "󰨙 UI" },
    p = { name = "󰏖 Packages" },
    pl = { "<cmd>Lazy<cr>", "Lazy" },
  }, { mode = "n", prefix = "<leader>" })

  wk.register({
    f = { name = "󰛔 Find & Replace" },
  }, { mode = "v", prefix = "<leader>" })

  wk.register({
    ["<SNR>"] = { name = "Script Number" },
    ["<leader>"] = { name = "Show Custom Key Map" },
    ["<localleader>"] = { "<cmd>WhichKey<cr>", "Show Key Map" },

    g = { name = "Goto" },
    gug = { name = "Goto" },
    gui = { name = "Inside" },
    gua = { name = "Around" },
    guz = { name = "Z" },
    ["gu["] = { name = "Previous" },
    ["gu]"] = { name = "Next" },
    gUg = { name = "Goto" },
    gUi = { name = "Inside" },
    gUa = { name = "Around" },
    gUz = { name = "Z" },
    ["gU["] = { name = "previous" },
    ["gU]"] = { name = "next" },
    ["g~g"] = { name = "Goto" },
    ["g~i"] = { name = "Inside" },
    ["g~a"] = { name = "Around" },
    ["g~z"] = { name = "Z" },
    ["g~["] = { name = "Previous" },
    ["g~]"] = { name = "Next" },
    ["g'"] = { name = "Marks" },
    ["g`"] = { name = "Marks" },
    z = { name = "Z" },
    zfg = { name = "Goto" },
    zfi = { name = "Inside" },
    zfa = { name = "Around" },
    zfz = { name = "Z" },
    ["zf["] = { name = "Previous" },
    ["zf]"] = { name = "Next" },
    yg = { name = "Goto" },
    yi = { name = "Inside" },
    ya = { name = "Around" },
    yz = { name = "Z" },
    ["y["] = { name = "Previous" },
    ["y]"] = { name = "Next" },
    vg = { name = "Goto" },
    vi = { name = "Inside" },
    va = { name = "Around" },
    vz = { name = "Z" },
    ["v["] = { name = "Previous" },
    ["v]"] = { name = "Next" },
    dg = { name = "Goto" },
    di = { name = "Inside" },
    da = { name = "Around" },
    dz = { name = "Z" },
    ["d["] = { name = "Previous" },
    ["d]"] = { name = "Next" },
    cg = { name = "Goto" },
    ci = { name = "Inside" },
    ca = { name = "Around" },
    cz = { name = "Z" },
    ["c["] = { name = "Previous" },
    ["c]"] = { name = "Next" },

    ["["] = { name = "Previous" },
    ["]"] = { name = "Next" },
    ["@"] = { name = "Registers" },
    ['"'] = { name = "Registers" },
    ["'"] = { name = "Marks" },
    ["`"] = { name = "Marks" },
    ["<c-w>"] = { name = "Window" },
  }, { mode = "n", prefix = "" })
end

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
map.set("n", "<leader>ua", option.toggle_mouse, "Toggle mouse")
map.set("n", "<leader>ue", option.toggle("spell"), "Toggle spell check")
map.set("n", "<leader>uw", option.toggle("wrap"), "Toggle wrap")
map.set("n", "<leader>un", option.toggle("number"), "Toggle number")
map.set("n", "<leader>ur", option.toggle("relativenumber"), "Toggle relative number")
map.set("n", "<leader>uc", option.toggle("cursorline"), "Toggle cursorline")
map.set("n", "<leader>uv", option.toggle("cursorcolumn"), "Toggle cursorcolumn")
map.set("n", "<leader>uf", option.toggle("foldenable"), "Toggle foldenable")
map.set("n", "<leader>ud", option.toggle("foldcolumn", false, { "0", "1" }), "Toggle foldcolumn")
map.set("n", "<leader>ul", option.toggle("list"), "Toggle list")
map.set("n", "<leader>uc", "<cmd>ColorizerToggle<cr>", "Toggle colorizer")
if vim.lsp.inlay_hint then
  map("n", "<leader>uh", utils.func.call(vim.buf.inlay_hint, { 0, nil }), "Toggle inlay hints")
end

map.set("n", "<leader>rj", function()
  local buffers = vim.api.nvim_list_bufs()
  local wins = vim.api.nvim_list_wins()

  if #wins > 1 or #buffers > 1 then
    vim.cmd([[silent wa | silent %bd | Alpha]])
  end

  vim.cmd([[Telescope projects theme=dropdown ]])

  -- if vim.bo.filetype == "alpha" then
  --   return
  -- end
end, "Recently")
map.set("n", "<leader>ra", "<cmd>AddProject<cr>", "Add")

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup(utils.title.add("Keymap"), { clear = true }),
  pattern = { "*" },
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }

    if vim.bo[event.buf].filetype == "alpha" then
      return
    end

    wk.register({
      -- d = { name = " Debugger" },
      c = { name = " ShortCuts" },
      b = { name = "󰓩 Buffers" },
      w = { name = " Window Split" },
      u = { name = "󰨙 UI" },
    }, { mode = "n", prefix = "<leader>", buffer = event.buf })

    -- 窗口切换组合快捷键
    map.set("n", "<C-j>", "<C-W><C-j>", "Down window", opts)
    map.set("n", "<C-k>", "<C-W><C-k>", "Up window", opts)
    map.set("n", "<C-l>", "<C-W><C-l>", "Left window", opts)
    map.set("n", "<C-h>", "<C-W><C-h>", "Right window", opts)
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
    -- 窗口快速跳转
    map.set("n", "<leader>1", "<cmd>1wincmd w<cr>", "Win 1", opts)
    map.set("n", "<leader>2", "<cmd>2wincmd w<cr>", "Win 2", opts)
    map.set("n", "<leader>3", "<cmd>3wincmd w<cr>", "Win 3", opts)
    map.set("n", "<leader>4", "<cmd>4wincmd w<cr>", "Win 4", opts)
    map.set("n", "<leader>5", "<cmd>5wincmd w<cr>", "Win 5", opts)
    map.set("n", "<leader>6", "<cmd>6wincmd w<cr>", "Win 6", opts)
    map.set("n", "<leader>7", "<cmd>7wincmd w<cr>", "Win 7", opts)
    map.set("n", "<leader>8", "<cmd>8wincmd w<cr>", "Win 8", opts)
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

    map.set("n", "<leader>q", function()
      vim.ui.select({ "Yes", "No" }, {
        prompt = "Comfirm to quit?",
        telescope = require("telescope.themes").get_dropdown({
          winblend = 0,
          layout_config = {
            width = 0.22,
            height = 0.12,
          },
        }),
      }, function(choice)
        if choice ~= "Yes" then
          return
        end
        vim.cmd([[ wa | quitall ]])
      end)
    end, " Quit", opts)

    map.set("n", "<leader>;", function()
      utils.func.call(require("notify").dismiss, { silent = true, pending = true })
      require("spectre").close()
      vim.cmd([[ Neotree close ]])
      vim.cmd([[ TroubleClose ]])
      vim.cmd([[silent wa | silent %bd | Alpha]])
    end, "󰧨 Dashboard", opts)

    if lazy.has("vim-easy-align") then
      map.set({ "x", "n" }, "gs", "<Plug>(EasyAlign)", "EasyAlign", { buffer = event.buf, noremap = false })
    end

    if lazy.has("hop.nvim") then
      local opt = { current_line_only = true }
      local hop = require("hop")
      local hint = require("hop.hint").HintDirection
      local function extend(ex)
        return function()
          hop.hint_char1(vim.tbl_deep_extend("force", opt, ex))
        end
      end
      map.set("", "f", extend({ direction = hint.AFTER_CURSOR }), "Jump forward", opts)
      map.set("", "F", extend({ direction = hint.BEFORE_CURSOR }), "Jump backward", opts)
      map.set("", "t", extend({ direction = hint.AFTER_CURSOR, hint_offset = -1 }), "Jump forward", opts)
      map.set("", "T", extend({ direction = hint.BEFORE_CURSOR, hint_offset = 1 }), "Jump backward", opts)

      map.set("n", "<leader>hw", "<cmd>HopWord<cr>", "Word", opts)
      map.set("n", "<leader>hl", "<cmd>HopLine<cr>", "Line", opts)
      map.set("n", "<leader>hc", "<cmd>HopChar1<cr>", "Char", opts)
      map.set("n", "<leader>hp", "<cmd>HopPattern<cr>", "Pattern", opts)
      map.set("n", "<leader>hs", "<cmd>HopLineStart<cr>", "Line start", opts)
      map.set("n", "<leader>haw", "<cmd>HopWordMW<cr>", "Word", opts)
      map.set("n", "<leader>hal", "<cmd>HopLineMW<cr>", "Line", opts)
      map.set("n", "<leader>hac", "<cmd>HopChar1MW<cr>", "Char", opts)
      map.set("n", "<leader>hap", "<cmd>HopPatternMW<cr>", "Pattern", opts)
      map.set("n", "<leader>has", "<cmd>HopLineStartMW<cr>", "Line start", opts)

      wk.register({
        h = { name = "󱖹 Hop" },
        ha = { name = "All Windows" },
      }, { mode = "n", prefix = "<leader>", buffer = event.buf })
    end

    if lazy.has("mini.bufremove") then
      map.set("n", "<leader>bd", utils.func.call(require("mini.bufremove").delete, 0, false), "Delete buffer", opts)
    end

    if lazy.has("bufferline.nvim") then
      map.set("n", "<leader>bt", "<Cmd>BufferLineTogglePin<CR>", "Toggle pin", opts)
      map.set("n", "<leader>bT", "<Cmd>BufferLineGroupClose ungrouped<CR>", "Delete non-pinned buffers", opts)
      map.set("n", "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", "Previous buffer", opts)
      map.set("n", "<leader>bn", "<cmd>BufferLineCycleNext<cr>", "Next buffer", opts)
      map.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", "Previous buffer", opts)
      map.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", "Next buffer", opts)
      map.set("n", "<leader>bk", "<cmd>BufferLinePick<cr>", "Pick buffer", opts)
      map.set("n", "<leader>b1", "<cmd>BufferLineGoToBuffer 1<cr>", "Buffer 1", opts)
      map.set("n", "<leader>b2", "<cmd>BufferLineGoToBuffer 2<cr>", "Buffer 2", opts)
      map.set("n", "<leader>b3", "<cmd>BufferLineGoToBuffer 3<cr>", "Buffer 3", opts)
      map.set("n", "<leader>b4", "<cmd>BufferLineGoToBuffer 4<cr>", "Buffer 4", opts)
      map.set("n", "<leader>b5", "<cmd>BufferLineGoToBuffer 5<cr>", "Buffer 5", opts)
      map.set("n", "<leader>b6", "<cmd>BufferLineGoToBuffer 6<cr>", "Buffer 6", opts)
      map.set("n", "<leader>b7", "<cmd>BufferLineGoToBuffer 7<cr>", "Buffer 7", opts)
      map.set("n", "<leader>b8", "<cmd>BufferLineGoToBuffer 8<cr>", "Buffer 8", opts)
    end

    if lazy.has("smart-splits.nvim") then
      map.set("n", "<leader>us", utils.func.call(require("smart-splits").start_resize_mode), "Resize Mode", opts)
      map.set("n", "<leader>uS", "<cmd>tabdo wincmd =<cr>", "Resume size", opts)
    end

    if lazy.has("git-blame.nvim") and utils.git.is_repo() then
      map.set("n", "<leader>gb", "<cmd>GitBlameToggle<cr>", "Toggle line blame", opts)
    end
  end,
})

if utils.git.is_repo() then
  wk.register({ g = { name = "󰊢 Git" }, mode = { "n", "v" }, prefix = "<leader>" })

  local opts = { border = "rounded", cmd = utils.path.get_root, esc_esc = false, ctrl_hjkl = false }
  map.set("n", "<leader>gg", utils.func.call(lazy.float_term, { "lazygit" }, opts), "Lazygit")
  map.set("n", "<leader>gl", utils.func.call(lazy.float_term, { "lazygit", "log" }, opts), "Lazygit log")
end
