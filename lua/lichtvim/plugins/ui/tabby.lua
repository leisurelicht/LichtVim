local str = require("lichtvim.utils").str

return {
  {
    "nanozuki/tabby.nvim",
    config = function()
      local t_name = require("tabby.feature.tab_name")
      local t_api = require("tabby.module.api")
      require("tabby.tabline").set(function(line)
        return {
          { { "  ", hl = "LichtTLHead" }, line.sep("", "LichtTLHead", "LichtTLLineSep") },
          line.tabs().foreach(function(tab)
            local tab_name = tab.name()

            if t_api.is_float_win(0) then
              return
            end

            local tnl = vim.fn.tolower(tab_name)
            if str.starts_with(tnl, "nvimtree") or str.starts_with(tnl, "neo-tree") then
              tab_name = "File Explorer"
            end

            if #tab.wins() == 0 then
              local buf = tab.current_win().buf().id
              local ft = vim.api.nvim_buf_get_option(buf, "filetype")
              if ft == "alpha" then
                tab_name = "Alpha"
              elseif ft == "checkhealth" then
                tab_name = "CheckHealth"
              end
            end

            local hl = tab.is_current() and "LichtTLActiveTab" or "LichtTLUnActive"
            return {
              line.sep(" ", hl, "LichtTLLineSep"),
              tab.is_current() and "" or "",
              tab.number(),
              tab_name,
              tab.is_current() and tab.close_btn("") or "",
              line.sep("", hl, "LichtTLLineSep"),
              hl = hl,
              margin = " ",
            }
          end),
          line.spacer(),
          line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            if t_api.is_float_win(0) then
              return
            end

            local win_name = win.buf_name()

            local ft = vim.api.nvim_buf_get_option(0, "filetype")
            if ft == "alpha" then
              win_name = "Alpha"
            elseif ft == "checkhealth" then
              win_name = "CheckHealth"
            end

            local wnl = vim.fn.tolower(win_name)
            if str.starts_with(wnl, "nvimtree") or str.starts_with(wnl, "neo-tree") then
              win_name = "File Explorer"
            end

            local hl = win.is_current() and "LichtTLActiveWin" or "LichtTLUnActive"
            return {
              line.sep(" ", hl, "LichtTLLineSep"),
              win.is_current() and "" or "",
              win_name,
              line.sep("", hl, "LichtTLLineSep"),
              hl = hl,
              margin = " ",
            }
          end),
          { line.sep(" ", "LichtTLTail", "LichtTLLineSep"), { " ", hl = "LichtTLTail" } },
          hl = "LichtTLLineSep",
        }
      end)
    end,
  },
}
