M = {}

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
  if vim.wo.spell then
    vim.wo.spell = false
    vim.notify("Spell check: off", "info", { title = LichtVimTitle })
  else
    vim.wo.spell = true
    vim.notify("Spell check: on", "info", { title = LichtVimTitle })
  end
end

function M.toggle_wrap()
  if vim.wo.wrap then
    vim.wo.wrap = false
    vim.notify("Wrap: off", "info", { title = LichtVimTitle })
  else
    vim.wo.wrap = true
    vim.notify("Wrap: on", "info", { title = LichtVimTitle })
  end
end

function M.toggle_number()
  if vim.wo.number then
    vim.wo.number = false
    vim.notify("Number: off", "info", { title = LichtVimTitle })
  else
    vim.wo.number = true
    vim.notify("Number: on", "info", { title = LichtVimTitle })
  end
end

function M.toggle_relativenumber()
  if vim.wo.relativenumber then
    vim.wo.relativenumber = false
    vim.notify("RelativeNumber: off", "info", { title = LichtVimTitle })
  else
    vim.wo.relativenumber = true
    vim.notify("RelativeNumber: on", "info", { title = LichtVimTitle })
  end
end

function M.toggle_cursorline()
  if vim.wo.cursorline then
    vim.wo.cursorline = false
    vim.notify("CursorLine: off", "info", { title = LichtVimTitle })
  else
    vim.wo.cursorline = true
    vim.notify("CursorLine: on", "info", { title = LichtVimTitle })
  end
end

function M.toggle_cursorcolumn()
  if vim.wo.cursorcolumn then
    vim.wo.cursorcolumn = false
    vim.notify("CursorColumn: off", "info", { title = LichtVimTitle })
  else
    vim.wo.cursorcolumn = true
    vim.notify("CursorColumn: on", "info", { title = LichtVimTitle })
  end
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
  if vim.wo.foldenable then
    vim.wo.foldenable = false
    vim.notify("FoldEnable: off", "info", { title = LichtVimTitle })
  else
    vim.wo.foldenable = true
    vim.notify("FoldEnable: on", "info", { title = LichtVimTitle })
  end
end

function M.toggle_list()
  if vim.wo.list then
    vim.wo.list = false
    vim.notify("List: off", "info", { title = LichtVimTitle })
  else
    vim.wo.list = true
    vim.notify("List: on", "info", { title = LichtVimTitle })
  end
end

return M
