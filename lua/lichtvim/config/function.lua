M = {}

-- 切换 mouse 模式
function M.toggle_mouse()
  if vim.o.mouse == "a" then
    vim.o.mouse = ""
    vim.notify("Mouse mode: off", vim.log.levels.INFO, { title = LichtVimTitle })
  else
    vim.o.mouse = "a"
    vim.notify("Mouse mode: on", vim.log.levels.INFO, { title = LichtVimTitle })
  end
end

function M.smart_add_term()
  if vim.b.toggle_number == nil then
    vim.notify("Create A Terminal And Move In Please")
    return
  end

  local direction = require("toggleterm.ui").guess_direction()

  if direction == nil then
    if vim.g._term_direction == 1 then
      direction = "vertical"
    elseif vim.g._term_direction == 2 then
      direction = "horizontal"
    elseif vim.g._term_direction == 0 then
      vim.notify("Can Not Add A Terminal Window", vim.log.levels.INFO)
      return
    end
  end

  if direction == "vertical" then
    vim.cmd("exe b:toggle_number+1.'ToggleTerm direction=vertical'")
    vim.g._term_direction = 1
  elseif direction == "horizontal" then
    vim.cmd("exe b:toggle_number+1.'ToggleTerm direction=horizontal'")
    vim.g._term_direction = 2
  end
end

return M
