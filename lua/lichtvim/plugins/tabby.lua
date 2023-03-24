local str = require("lichtvim.utils").str

local theme = {
  fill = "TabLineFill",
  head = "TabLine",
  current_tab = "TabLineSel",
  tab = "TabLine",
  win = "TabLine",
  tail = "TabLine"
}

return {
  "nanozuki/tabby.nvim",
  event = "VeryLazy",
  config = function()
    require("tabby.tabline").set(function(line)
      return {
        {{"  ", hl = theme.head}, line.sep("", theme.head, theme.fill)},
        line.tabs().foreach(function(tab)
          local hl = tab.is_current() and theme.current_tab or theme.tab
          return {
            line.sep("", hl, theme.fill),
            tab.is_current() and "" or "",
            tab.number(),
            tab.name(),
            tab.is_current() and tab.close_btn("") or "",
            line.sep("", hl, theme.fill),
            hl = hl,
            margin = " "
          }
        end),
        line.spacer(),
        line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
          local win_name = win.buf_name()
          if str.starts_with(vim.fn.toupper(win_name), "NVIMTREE") then
            win_name = "Explorer"
          end
          return {
            line.sep("", theme.win, theme.fill),
            win.is_current() and "" or "",
            win_name,
            line.sep("", theme.win, theme.fill),
            hl = theme.win,
            margin = " "
          }
        end),
        {line.sep("", theme.tail, theme.fill), {"  ", hl = theme.tail}},
        hl = theme.fill
      }
    end)
    map.set("n", "<leader>tmp", "<CMD>-tabmove<CR>", "Tab Move Previous")
    map.set("n", "<leader>tmn", "<CMD>+tabmove<CR>", "Tab Move Next")
  end
}
