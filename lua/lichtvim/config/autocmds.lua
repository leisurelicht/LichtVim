-- =================
-- autocmds.lua
-- Note: 自动命令配置
-- =================
--
local options = require("lichtvim.config")

-- auto save when leaving insert mode or when the buffer is changed
if options.auto_save then
  vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    pattern = { "*" },
    command = "silent! wall",
    nested = true,
  })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = vim.api.nvim_create_augroup(utils.title.add("Checktime"), { clear = true }),
  command = "checktime",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup(utils.title.add("HighlightYank"), { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup(utils.title.add("CloseWithQ"), { clear = true }),
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
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- close some filetypes with <esc>
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup(utils.title.add("CloseWithEsc"), { clear = true }),
  pattern = {
    "lazy",
    "help",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "<esc>", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup(utils.title.add("LastLocation"), { clear = true }),
  callback = function()
    local exclude = { "gitcommit" }
    local buf = vim.api.nvim_get_current_buf()
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, buf, mark)
    end
  end,
})

-- auto close lazy and notify buffers when leaving them
vim.api.nvim_create_autocmd("BufLeave", {
  group = vim.api.nvim_create_augroup(utils.title.add("CloseFloat"), { clear = true }),
  callback = function(event)
    local buf = event.buf
    local ft = vim.api.nvim_buf_get_option(buf, "filetype")
    if ft == "lazy" or ft == "notify" then
      local winids = vim.fn.win_findbuf(buf)
      for _, win in pairs(winids) do
        vim.api.nvim_win_close(win, true)
      end
    end
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup(utils.title.add("WrapSpell"), { clear = true }),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- resize splits if window got resized
-- vim.api.nvim_create_autocmd({ "VimResized" }, {
--   group = vim.api.nvim_create_augroup(utils.title.add"resize_splits", { clear = true }),
--   callback = function()
--     vim.cmd("tabdo wincmd =")
--   end,
-- })
