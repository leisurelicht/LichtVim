-- =================
-- autocmds.lua
-- Note: 自动命令配置
-- =================
--
-- Check if we need to reload the file when it changed
api.autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = api.augroup("checktime"),
  command = "checktime",
})

-- Highlight on yank
api.autocmd("TextYankPost", {
  group = api.augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- close some filetypes with <q>
api.autocmd("FileType", {
  group = api.augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query", -- :InspectTree
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "noice",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- close some filetypes with <esc>
-- api.autocmd("FileType", {
--   group = api.augroup("close_with_esc"),
--   pattern = {
--     "PlenaryTestPopup",
--     "help",
--     "lspinfo",
--     "man",
--     "notify",
--     "qf",
--     "query", -- :InspectTree
--     "spectre_panel",
--     "startuptime",
--     "tsplayground",
--     "noice",
--   },
--   callback = function(event)
--     vim.bo[event.buf].buflisted = false
--     vim.keymap.set("n", "<esc>", "<cmd>close<cr>", { buffer = event.buf, silent = true })
--   end,
-- })

-- wrap and check for spell in text filetypes
api.autocmd("FileType", {
  group = api.augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

api.autocmd("FileType", {
  group = api.augroup("find"),
  pattern = { "TelescopePrompt" },
  callback = function()
    for _, win in pairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.api.nvim_buf_get_option(buf, "filetype")
      -- close telescope prompt window
      if ft == "lazy" then
        vim.api.nvim_win_close(win, true)
      end
    end
  end,
})

-- resize splits if window got resized
-- api.autocmd({ "VimResized" }, {
--   group = api.augroup("resize_splits"),
--   callback = function()
--     vim.cmd("tabdo wincmd =")
--   end,
-- })

-- go to last loc when opening a buffer
api.autocmd("BufReadPost", {
  group = api.augroup("last_loc"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
