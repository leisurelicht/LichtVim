local table = require("lichtvim.utils").table

M = {}

local function bool2str(bool)
  return bool and "on" or "off"
end

function notify(msg, type, opts)
  vim.schedule(function()
    vim.notify(msg, type, table.extend({ title = LichtVimTitle }, opts))
  end)
end

-- 切换 mouse 模式
function M.toggle_mouse()
  if vim.o.mouse == "a" then
    vim.o.mouse = ""
    vim.notify("Mouse mode: off", "info", { title = LichtVimTitle })
  else
    vim.o.mouse = "a"
    vim.notify("Mouse mode: on", "info", { title = LichtVimTitle })
  end
end

function M.toggle_spell()
  vim.wo.spell = not vim.wo.spell -- local to window
  notify(string.format("Spell Check : %s", bool2str(vim.wo.spell)))
end

function M.toggle_wrap()
  vim.wo.wrap = not vim.wo.wrap
  notify(string.format("Wrap : %s", bool2str(vim.wo.wrap)))
end

function M.toggle_number()
  vim.wo.number = not vim.wo.number
  notify(string.format("Number : %s", bool2str(vim.wo.number)))
end

function M.toggle_relativenumber()
  vim.wo.relativenumber = not vim.wo.relativenumber
  notify(string.format("Relative Number : %s", bool2str(vim.wo.relativenumber)))
end

function M.toggle_cursorline()
  vim.wo.cursorline = not vim.wo.cursorline
  notify(string.format("Cursor Line : %s", bool2str(vim.wo.cursorline)))
end

function M.toggle_cursorcolumn()
  vim.wo.cursorcolumn = not vim.wo.cursorcolumn
  notify(string.format("Cursor Column : %s", bool2str(vim.wo.cursorcolumn)))
end

function M.toggle_foldcolumn()
  if vim.wo.foldcolumn == "0" then
    vim.wo.foldcolumn = "1"
    vim.notify("FoldColumn: on", "info", { title = LichtVimTitle })
  else
    vim.wo.foldcolumn = "0"
    vim.notify("FoldColumn: off", "info", { title = LichtVimTitle })
  end
end

function M.toggle_foldenable()
  vim.wo.foldenable = not vim.wo.foldenable
  notify(string.format("Fold : %s", bool2str(vim.wo.cursorline)))
end

function M.toggle_list()
  vim.wo.list = not vim.wo.list
  notify(string.format("List : %s", bool2str(vim.wo.list)))
end

function M.toggle_paste()
  vim.opt.paste = not vim.opt.paste:get() -- local to window
  notify(string.format("Paste %s", bool2str(vim.opt.paste:get())))
end

return M
