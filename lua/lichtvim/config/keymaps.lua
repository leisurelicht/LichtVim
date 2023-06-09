-- =================
-- keybindings.lua
-- Note: 基础快捷键绑定设置
-- =================
--
-- local fn = require("lichtvim.config.function")
local table = require("lichtvim.utils").table
local git = require("lichtvim.utils").git
local lsp = require("lichtvim.utils").lsp
local list = require("lichtvim.utils").list
local option = require("lichtvim.utils").option
local plugs = require("lichtvim.utils").plugs
local Keys = require("lazy.core.handler.keys")
local format = require("lichtvim.plugins.lsp.config.format").format
local toggle = require("lichtvim.plugins.lsp.config.format").toggle

if lazy.has("which-key.nvim") then
  local wk = require("which-key")
  wk.register({
    [";"] = { "<cmd>Alpha<cr>", "󰧨 Dashboard" },
    ["q"] = { "<cmd>confirm q<cr>", " Quit" },
    -- d = { name = " Debugger" },
    f = { name = "󰛔 Find & Replace" },
    o = { name = " Terminal" },
    c = { name = " ShortCuts" },
    b = { name = "󰓩 Buffers" },
    s = { name = " Split" },
    t = { name = "󱏈 Tab" },
    to = { name = "Close Only" },
    u = { name = "󰨙 UI" },
    p = { name = "󰏖 Packages" },
    pl = { "<cmd>Lazy<cr>", "Lazy" },
  }, { mode = "n", prefix = "<leader>" })

  wk.register({
    f = { name = "󰛔 Find & Replace" },
  }, { mode = "v", prefix = "<leader>" })

  -- wk.register({}, { mode = "n", prefix = "<localleader>" })

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
else
  vim.notify("Need to install which-key.nvim", vim.log.levels.ERROR)
end

map.set("c", "w!!", "w !sudo tee > /dev/null %", "saved") -- 强制保存
map.set("i", "<C-u>", "<esc>viwUea", "Upper word") -- 一键大写
map.set("i", "<C-l>", "<esc>viwuea", "Lower word") -- 一键小写
map.set("i", "<C-O>", "<ESC>wb~ea") -- 首字母大写
-- normal 模式下按 esc 取消高亮显示
map.set("n", "<esc>", function()
  vim.cmd("silent! noh")
end, "No highlight")

-- 窗口切换组合快捷键
map.set("n", "<C-j>", "<C-W><C-j>", "Down window")
map.set("n", "<C-k>", "<C-W><C-k>", "Up window")
map.set("n", "<C-l>", "<C-W><C-l>", "Left window")
map.set("n", "<C-h>", "<C-W><C-h>", "Right window")
-- 行移动
map.set("v", "J", ":m '>+1<cr>gv=gv", "Move line down")
map.set("v", "K", ":m '<-2<cr>gv=gv", "Move line up")
-- 连续缩进
map.set("v", "<", "<gv", "Move left continuously")
map.set("v", ">", ">gv", "Move right continuously")
-- 分屏
map.set("n", "<leader>sh", "<cmd>vertical leftabove sbuffer<cr>", "Left")
map.set("n", "<leader>sl", "<cmd>vertical rightbelow sbuffer<cr>", "Right")
map.set("n", "<leader>sk", "<cmd>horizontal aboveleft sbuffer<cr>", "Above")
map.set("n", "<leader>sj", "<cmd>horizontal belowright sbuffer<cr>", "Below")
map.set("n", "<leader>sy", "<cmd>vertical topleft sbuffer<cr>", "Far left")
map.set("n", "<leader>so", "<cmd>vertical botright sbuffer<cr>", "Far right")
map.set("n", "<leader>si", "<cmd>horizontal topleft sbuffer<cr>", "Top")
map.set("n", "<leader>su", "<cmd>horizontal botright sbuffer<cr>", "Bottom")
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
-- buffer
map.set("n", "<leader>bf", "<cmd>bfirst<cr>", "First buffer")
map.set("n", "<leader>bl", "<cmd>blast<cr>", "Last buffer")
map.set("n", "<leader>bp", "<cmd>bprev<cr>", "Previous buffer")
map.set("n", "<leader>bn", "<cmd>bnext<cr>", "Next buffer")
map.set("n", "[b", "<cmd>bprev<cr>", "Previous buffer")
map.set("n", "]b", "<cmd>bnext<cr>", "Next buffer")
map.set("n", "<leader>bs", "<cmd>buffers<cr>", "Buffers")
-- map.set("n", "<leader>bd", "<cmd>bdelete<cr>", "Delete buffer")
-- shortcuts
map.set("n", "<leader>cl", "viwue", "Lower word")
map.set("n", "<leader>cu", "viwUe", "Upper word")
map.set("n", "<leader>co", "wb~ea", "Upper first word")
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

if lazy.has("neo-tree.nvim") then
  map.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", " Explorer")
elseif lazy.has("nvim-tree.lua") then
  map.set("n", "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", " Explorer")
end

if lazy.has("nvim-treesitter") then
  map.set("n", "<leader>pt", "<cmd>TSUpdate all<cr>", "Treesitter update")
  map.set("n", "<leader>pT", "<cmd>TSModuleInfo<cr>", "Treesitter info")
end

if lazy.has("vim-im-select") then
  map.set("n", "<leader>ui", "<cmd>ImSelectEnable<cr>", "Enable imselect")
  map.set("n", "<leader>uI", "<cmd>ImSelectDisable<cr>", "Disable imselect")
end

if lazy.has("todo-comments.nvim") then
  if lazy.has("telescope.nvim") then
    map.set("n", "<leader>ft", "<cmd>TodoTelescope theme=ivy<cr>", "Todo")
  else
    map.set("n", "<leader>ft", "<cmd>TodoLocList<cr>", "Todo (LocList)")
  end
end

if lazy.has("nvim-spectre") then
  map.set("n", "<leader>frr", "<cmd>lua require('spectre').open()<cr>", "Spectre")
  map.set("n", "<leader>frw", "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "Replace current word")
  map.set("v", "<leader>frw", "<cmd>lua require('spectre').open_visual()<cr>", "Replace current word")
  map.set(
    "n",
    "<leader>frs",
    "<cmd>lua require('spectre').open_file_search({select_word=true})<cr>",
    "Replace current word in current file"
  )

  require("which-key").register({
    fr = { name = "Replace" },
  }, { mode = { "n", "v" }, prefix = "<leader>" })
end

if lazy.has("telescope.nvim") then
  local telescope = plugs.telescope

  map.set("n", "<leader>fT", telescope("builtin"), "Builtin")
  map.set("n", "<leader>f<tab>", telescope("commands"), "Commands")
  map.set("n", "<leader>fc", telescope("command_history"), "Commands history")
  map.set("n", "<leader>fs", telescope("search_history"), "Search history")
  map.set("n", "<leader>fA", telescope("autocommands"), "AutoCommands")
  map.set("n", "<leader>ff", telescope("files"), "Files (root dir)")
  map.set("n", "<leader>ff", telescope("files", { cwd = false }), "Files (cwd)")
  map.set("n", "<leader>fH", telescope("help_tags"), "Help tags")
  map.set("n", "<leader>fm", telescope("marks"), "Marks")
  map.set("n", "<leader>fM", telescope("man_pages"), "Man pages")
  map.set("n", "<leader>fo", telescope("oldfiles"), "Recently files")
  map.set("n", "<leader>fO", telescope("oldfiles", { cwd = vim.loop.cwd() }), "Recently files (cwd)")
  map.set("n", "<leader>fP", telescope("vim_options"), "Vim option")
  map.set("n", "<leader>fg", telescope("live_grep"), "Grep (root dir)")
  map.set("n", "<leader>fG", telescope("live_grep", { cwd = false }), "Grep (cwd)")
  map.set("n", "<leader>fw", telescope("grep_string"), "Word (root dir)")
  map.set("n", "<leader>fW", telescope("grep_string", { cwd = false }), "Word (cwd)")
  map.set("n", "<leader>fk", telescope("keymaps"), "Key maps")
  map.set("n", "<leader>fb", telescope("buffers"), "Buffers")
  map.set("n", "<leader>fJ", telescope("jumplist"), "Jump list")
  map.set("n", "<leader>fC", telescope("colorscheme", { enable_preview = true }), "Colorscheme")
  map.set("n", "<leader>fp", "<cmd>Telescope neoclip a extra=star,plus,b theme=dropdown<cr>", "Paster")
  map.set("n", "<leader>fe", function()
    require("telescope").extensions.file_browser.file_browser({ path = vim.fn.expand("~") })
  end, "File Browser")

  map.set("n", "<leader>bs", telescope("buffers"), "Buffers")
end

if lazy.has("project.nvim") and lazy.has("telescope.nvim") then
  map.set("n", "<leader>fj", "<cmd>Telescope projects theme=dropdown<cr>", "Projects")
end

if lazy.has("nvim-notify") then
  map.set("n", "<leader>uq", function()
    require("notify").dismiss({ silent = true, pending = true })
  end, "Clear notifications")

  if lazy.has("telescope.nvim") then
    map.set("n", "<leader>fn", "<cmd>Telescope notify theme=dropdown<cr>", "Notify")
  end
end

if lazy.has("toggleterm.nvim") then
  map.set("n", "<C-\\>", "<CMD>exe v:count1 . 'ToggleTerm'<CR>", "Toggle terminal")
  map.set("n", "<leader>of", "<CMD>ToggleTerm direction=float<CR>", "Toggle in float")
  map.set("n", "<leader>ot", "<CMD>ToggleTerm direction=tab<CR>", "Toggle in tab")
  map.set("n", "<leader>oh", "<CMD>ToggleTerm direction=horizontal<CR>", "Toggle in horizontal")
  map.set("n", "<leader>ov", "<CMD>ToggleTerm direction=vertical<CR>", "Toggle in vertical")
  map.set("n", "<leader>or", "<CMD>ToggleTermSendCurrentLine<CR>", "Send current line")
  map.set("n", "<leader>or", "<CMD>ToggleTermSendVisualLines<CR>", "Send visual lines")
  map.set("n", "<leader>os", "<CMD>ToggleTermSendVisualSelection<CR>", "Send visual selection")

  vim.api.nvim_create_autocmd({ "TermOpen" }, {
    group = vim.api.nvim_create_augroup(add_title("term_keymap"), { clear = true }),
    pattern = { "term://*" },
    callback = function()
      local opts = { buffer = 0 }
      map.set("t", "<space><esc>", [[<C-\><C-n>]], "Esc", opts)
      map.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], "Up", opts)
      map.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], "Down", opts)
      map.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], "Left", opts)
      map.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], "Right", opts)
      map.set("t", "<C-o>", plugs.smart_add_terminal, "Add new terminal", opts)
    end,
  })
end

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = vim.api.nvim_create_augroup(add_title("keybind"), { clear = true }),
  callback = function()
    if lazy.has("vim-easy-align") then
      map.set({ "x", "n" }, "gs", "<Plug>(EasyAlign)", "EasyAlign", { noremap = false })
    end

    if lazy.has("hop.nvim") then
      local opt = { current_line_only = true }
      -- stylua: ignore
      map.set("", "f", function() require("hop").hint_char1(table.extend(opt, { direction = require("hop.hint").HintDirection.AFTER_CURSOR })) end, "Jump forward")
      -- stylua: ignore
      map.set("", "F", function() require("hop").hint_char1(table.extend(opt, { direction = require("hop.hint").HintDirection.BEFORE_CURSOR })) end, "Jump backward")
      -- stylua: ignore
      map.set("", "t", function() require("hop").hint_char1(table.extend(opt, { direction = require("hop.hint").HintDirection.AFTER_CURSOR, hint_offset = -1 })) end, "Jump forward")
      -- stylua: ignore
      map.set("", "T", function() require("hop").hint_char1(table.extend(opt, { direction = require("hop.hint").HintDirection.BEFORE_CURSOR, hint_offset = 1 })) end, "Jump backward")

      map.set("n", "<leader>hw", "<cmd>HopWord<cr>", "Word")
      map.set("n", "<leader>hl", "<cmd>HopLine<cr>", "Line")
      map.set("n", "<leader>hc", "<cmd>HopChar1<cr>", "Char")
      map.set("n", "<leader>hp", "<cmd>HopPattern<cr>", "Pattern")
      map.set("n", "<leader>hs", "<cmd>HopLineStart<cr>", "Line start")
      map.set("n", "<leader>haw", "<cmd>HopWordMW<cr>", "Word")
      map.set("n", "<leader>hal", "<cmd>HopLineMW<cr>", "Line")
      map.set("n", "<leader>hac", "<cmd>HopChar1MW<cr>", "Char")
      map.set("n", "<leader>hap", "<cmd>HopPatternMW<cr>", "Pattern")
      map.set("n", "<leader>has", "<cmd>HopLineStartMW<cr>", "Line start")

      require("which-key").register({
        h = { name = "󱖹 Hop" },
        ha = { name = "All Windows" },
      }, { mode = "n", prefix = "<leader>" })
    end

    if lazy.has("nvim-hlslens") then
      map.set("n", "n", [[<cmd>execute('normal! '.v:count1.'n')<cr><cmd>lua require('hlslens').start()<cr>]], "Next")
      map.set("n", "N", [[<cmd>execute('normal! '.v:count1.'N')<cr><cmd>lua require('hlslens').start()<cr>]], "Prev")
      map.set("n", "*", [[*<cmd>lua require('hlslens').start()<cr>]], "Forward search")
      map.set("n", "#", [[#<cmd>lua require('hlslens').start()<cr>]], "Backward search")
      map.set("n", "g*", [[g*<cmd>lua require('hlslens').start()<cr>]], "Weak forward search")
      map.set("n", "g#", [[g#<cmd>lua require('hlslens').start()<cr>]], "Weak backward search")
    end

    if lazy.has("vim-matchup") then
      require("which-key").register({
        ["]%"] = "Jump to next matchup",
        ["[%"] = "Jump to previous matchup",
        ["g%"] = "Jump to close matchup",
        ["z%"] = "Jump inside matchup",
      }, { mode = "n" })
    end

    if lazy.has("mini.indentscope") then
      require("which-key").register({
        ["]i"] = "Goto indent scope bottom",
        ["[i"] = "Goto indent scope top",
      }, { mode = "n" })
    end

    if lazy.has("mini.bufremove") then
      map.set("n", "<leader>bd", function()
        require("mini.bufremove").delete(0, false)
      end, "Delete buffer")
    end

    if lazy.has("bufferline.nvim") then
      map.set("n", "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", "Toggle pin")
      map.set("n", "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", "Delete non-pinned buffers")
    end

    if lazy.has("smart-splits.nvim") then
      map.set("n", "<leader>us", function()
        require("smart-splits").start_resize_mode()
      end, "Resize Mode")
      map.set("n", "<leader>uS", "<cmd>tabdo wincmd =<cr>", "Resume size")
    end
  end,
})

if lazy.has("trouble.nvim") then
  map.set("n", "[q", function()
    if require("trouble").is_open() then
      require("trouble").previous({ skip_groups = true, jump = true })
    else
      vim.cmd.cprev()
    end
  end, "Previous trouble/quickfix item")
  map.set("n", "]q", function()
    if require("trouble").is_open() then
      require("trouble").next({ skip_groups = true, jump = true })
    else
      vim.cmd.cnext()
    end
  end, "Next trouble/quickfix item")
end

if lazy.has("mason.nvim") then
  map.set("n", "<leader>pm", "<cmd>Mason<cr>", "Mason")
end

map.set("n", "<leader>gg", function()
  require("lazy.util").float_term({ "lazygit" }, { border = "rounded", cwd = git.dir() })
end, "Lazygit")
map.set("n", "<leader>gl", function()
  require("lazy.util").float_term({ "lazygit", "log" }, { border = "rounded", cwd = git.dir() })
end, "Lazygit log")

require("which-key").register({
  g = { name = "󰊢 Git" },
}, { mode = { "n", "v" }, prefix = "<leader>" })

if lazy.has("telescope.nvim") then
  local telescope = require("lichtvim.utils").plugs.telescope
  map.set("n", "<leader>gC", telescope("git_bcommits"), "Buffer's Commits")
  map.set("n", "<leader>gc", telescope("git_commits"), "Commits")
  map.set("n", "<leader>gS", telescope("git_stash"), "Stash")
  map.set("n", "<leader>gn", telescope("git_branches"), "Branches")
  map.set("n", "<leader>gs", telescope("git_status"), "Status")
end

vim.api.nvim_create_autocmd({ "User" }, {
  group = vim.api.nvim_create_augroup(add_title("git_keybind"), { clear = true }),
  pattern = "Gitsigns",
  callback = function(event)
    local gs = package.loaded.gitsigns
    local bufnr = event.buf
    map.set("n", "<leader>gB", "<cmd>GitBlameToggle<cr>", "Toggle line blame")
    map.set("n", "<leader>go", "<cmd>GitBlameOpenCommitURL<cr>", "Open commit url")
    map.set("n", "<leader>ga", gs.stage_hunk, "Add hunk", { buffer = bufnr })
    map.set("v", "<leader>ga", function()
      gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Add hunk", { buffer = bufnr })
    map.set("n", "<leader>gr", gs.reset_hunk, "Reset hunk", { buffer = bufnr })
    map.set("v", "<leader>gr", function()
      gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Reset hunk", { buffer = bufnr })
    map.set("n", "<leader>gA", gs.stage_buffer, "Add buffer", { buffer = bufnr })
    map.set("n", "<leader>gR", gs.reset_buffer, "Reset buffer", { buffer = bufnr })
    map.set("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk", { buffer = bufnr })
    map.set("n", "<leader>gp", gs.preview_hunk, "Preview hunk", { buffer = bufnr })
    map.set("n", "<leader>gt", gs.toggle_deleted, "Toggle deleted", { buffer = bufnr })
    map.set("n", "<leader>gb", function()
      gs.blame_line({ full = true })
    end, "Show blame line", { buffer = bufnr })
    map.set("n", "<leader>gd", gs.diffthis, "Diff this", { buffer = bufnr })
    map.set("n", "<leader>gD", function()
      gs.diffthis("~")
    end, "Diff this?", { buffer = bufnr })

    map.set("n", "]g", function()
      if vim.wo.diff then
        return "]g"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, "Next git hunk", { buffer = bufnr, expr = true })
    map.set("n", "[g", function()
      if vim.wo.diff then
        return "[g"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, "Previous git hunk", { buffer = bufnr, expr = true })

    -- Text object
    map.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<cr>")
  end,
})

local _keys = {
  { "<leader>lI", "<cmd>LspInfo<cr>", desc = "Info" },
  { "<leader>ln", lsp.diagnostic_goto(true), desc = "Next diagnostic" },
  { "<leader>lp", lsp.diagnostic_goto(false), desc = "Previous diagnostic" },
  { "]d", lsp.diagnostic_goto(true), desc = "Next diagnostic" },
  { "[d", lsp.diagnostic_goto(false), desc = "Previous diagnostic" },
  { "]e", lsp.diagnostic_goto(true, "ERROR"), desc = "Next diagnostic (error)" },
  { "[e", lsp.diagnostic_goto(false, "ERROR"), desc = "Previous diagnostic (error)" },
  { "]w", lsp.diagnostic_goto(true, "WARN"), desc = "Next diagnostic (warning)" },
  { "[w", lsp.diagnostic_goto(false, "WARN"), desc = "Previous diagnostic (warning)" },
  { "<leader>lf", toggle, desc = "Toggle format", has = "documentFormatting" },
  { "<leader>lF", format, desc = "Format document", has = "documentFormatting" },
  { "<leader>lF", format, desc = "Format range", mode = "v", has = "documentRangeFormatting" },
  { "<leader>lk", vim.lsp.buf.signature_help, desc = "Signature help", has = "signatureHelp" },
  { "<c-k>", vim.lsp.buf.signature_help, desc = "Signature help", mode = "i", has = "signatureHelp" },
  { "<leader>lh", vim.lsp.buf.hover, desc = "Hover", has = "hover" },
  { "<leader>lr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
  { "<leader>la", vim.lsp.buf.code_action, mode = { "v", "n" }, desc = "Code action", has = "codeAction" },
    -- stylua: ignore
    { "<leader>ll", function() vim.diagnostic.open_float({ border = "rounded" }) end, desc = "Diagnostic (line)" },
    -- stylua: ignore
    { "<leader>lD", function() vim.lsp.buf.definition({ jump_type = "tab" }) end, desc = "Goto definition (tab)", has = "definition" },
}

if lazy.has("lspsaga.nvim") then
  local keys = {
    { "<leader>lh", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover", has = "hover" },
    { "<leader>lH", "<cmd>Lspsaga hover_doc ++keep<cr>", desc = "Hover", has = "hover" },
    { "<leader>ll", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Diagnostic (line)" },
    { "<leader>lc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", desc = "Diagnostic (cursor)" },
  }
  list.extend(_keys, keys)
end

if lazy.has("telescope.nvim") then
  local builtin = require("telescope.builtin")
  -- stylua: ignore
  local keys = {
    { "<leader>lL", function() builtin.diagnostics({}) end, desc = "Diagnostic (project)" },
    { "<leader>le", function() builtin.lsp_references({ show_line = false }) end, desc = "Goto references", has = "references" },
    { "<leader>li", function() builtin.lsp_implementations({ show_line = false }) end, desc = "Goto implementation", has = "implementation" },
    { "<leader>lt", function() builtin.lsp_type_definitions({ show_line = false }) end, desc = "Goto type definition", has = "typeDefinition" },
    { "<leader>ld", function() builtin.lsp_definitions({ reuse_win = true, show_line = false }) end, desc = "Goto definition", has = "definition" },
  }
  list.extend(_keys, keys)
end

vim.api.nvim_create_autocmd({ "LspAttach" }, {
  group = vim.api.nvim_create_augroup(add_title("lsp_keybind"), { clear = true }),
  callback = function(event)
    local buffer = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")

    local keymaps = {}
    for _, value in ipairs(_keys) do
      local keys = Keys.parse(value)
      if keys[2] == vim.NIL or keys[2] == false then
        keymaps[keys.id] = nil
      else
        keymaps[keys.id] = keys
      end
    end

    for _, keys in pairs(keymaps) do
      if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
        local opts = Keys.opts(keys)
        opts.has = nil
        opts.silent = opts.silent ~= false
        opts.buffer = buffer
        map.set(keys.mode or "n", keys[1], keys[2], nil, opts)
      end
    end

    if lazy.has("which-key.nvim") then
      require("which-key").register({
        l = { name = " LSP" },
        mode = { "n", "v" },
        prefix = "<leader>",
      })
    end

    if lazy.has("null-ls.nvim") then
      map.set("n", "<leader>pn", "<cmd>NullLsInfo<cr>", "Null-ls info")
    end
  end,
})
