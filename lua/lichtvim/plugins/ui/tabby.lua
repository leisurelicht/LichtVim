local str = require("lichtvim.utils").str

return {
  {
    "nanozuki/tabby.nvim",
    config = function()
      require("tabby.tabline").set(function(line)
        return {
          { { "  ", hl = "LichtTLHead" }, line.sep("", "LichtTLHead", "LichtTLLineSep") },
          line.tabs().foreach(function(tab)
            if vim.api.nvim_win_get_config(0).relative ~= "" then
              return
            end

            local tab_name = tab.name()

            local ft = vim.api.nvim_buf_get_option(0, "filetype")
            if ft == "alpha" then
              tab_name = "Alpha"
            else
              local tnl = vim.fn.tolower(tab_name)
              if str.starts_with(tnl, "nvimtree") or str.starts_with(tnl, "neo-tree") then
                tab_name = "File Explorer"
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
            if vim.api.nvim_win_get_config(0).relative ~= "" then
              return
            end

            local win_name = win.buf_name()

            local ft = vim.api.nvim_buf_get_option(0, "filetype")
            if ft == "alpha" then
              win_name = "Alpha"
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
