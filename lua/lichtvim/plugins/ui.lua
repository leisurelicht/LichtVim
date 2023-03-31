local str = require("lichtvim.utils").str
local icons_g = require("lichtvim.utils.ui.icons").git
local icons_d = require("lichtvim.utils.ui.icons").diagnostics
local fg = require("lichtvim.utils.ui.colors").fg

return {
  { "nvim-tree/nvim-web-devicons", lazy = true }, -- 图标
  { "MunifTanjim/nui.nvim", lazy = true }, -- ui components
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      routes = {
        -- { filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
        -- { view = "split", filter = { event = "msg_show", min_height = 20 } },
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>uc",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Clear Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    init = function()
      -- when noice is not enabled, install notify on VeryLazy
      if not lazy.has("noice.nvim") then
        lazy.on_very_lazy(function()
          vim.notify = require("notify")
        end)
      end
    end,
  },
  { -- better vim.ui
    "stevearc/dressing.nvim",
    enabled = true,
    event = "VeryLazy",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      {
        "<leader>ux",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        desc = "Document Diagnostics (Trouble)",
      },
      {
        "<leader>uX",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        desc = "Workspace Diagnostics (Trouble)",
      },
      {
        "<leader>uL",
        "<cmd>TroubleToggle loclist<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>uQ",
        "<cmd>TroubleToggle quickfix<cr>",
        desc = "Quickfix List (Trouble)",
      },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            vim.cmd.cprev()
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            vim.cmd.cnext()
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },
  {
    "nanozuki/tabby.nvim",
    event = "VeryLazy",
    config = function()
      local theme = {
        fill = "TabLineFill",
        head = "TabLine",
        current_tab = "TabLineSel",
        tab = "TabLine",
        win = "TabLine",
        tail = "TabLine",
      }
      require("tabby.tabline").set(function(line)
        return {
          { { "  ", hl = theme.head }, line.sep("", theme.head, theme.fill) },
          line.tabs().foreach(function(tab)
            local tab_name = tab.name()
            if str.starts_with(vim.fn.toupper(tab_name), "NVIMTREE") then
              tab_name = "File Explorer"
            end
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
              line.sep("", hl, theme.fill),
              tab.is_current() and "" or "",
              tab.number(),
              tab_name,
              tab.is_current() and tab.close_btn("") or "",
              line.sep("", hl, theme.fill),
              hl = hl,
              margin = " ",
            }
          end),
          line.spacer(),
          line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            local win_name = win.buf_name()
            if str.starts_with(vim.fn.toupper(win_name), "NVIMTREE") then
              win_name = "File Explorer"
            end
            return {
              line.sep("", theme.win, theme.fill),
              win.is_current() and "" or "",
              win_name,
              line.sep("", theme.win, theme.fill),
              hl = theme.win,
              margin = " ",
            }
          end),
          { line.sep("", theme.tail, theme.fill), { "  ", hl = theme.tail } },
          hl = theme.fill,
        }
      end)
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "gitsigns.nvim" },
    opts = function()
      local function window_num()
        -- local num = vim.inspect([[%{tabpagewinnr(tabpagenr())}]])
        local num = [[%{winnr()}]]
        return "[" .. num .. "]"
      end

      return {
        options = {
          theme = "auto",
          disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
          component_separators = { left = "\\", right = "/" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            {
              window_num,
              separator = { right = "" },
              color = { fg = "white", bg = "grey" },
            },
            {
              "mode",
              fmt = function(s)
                return s:sub(1, 1)
              end,
              separator = { right = "" },
            },
          },
          lualine_b = {
            { "branch", separator = { right = "" } },
            {
              "diff",
              symbols = {
                added = icons_g.added,
                modified = icons_g.modified,
                removed = icons_g.removed,
              },
              separator = { right = "" },
            },
          },
          lualine_c = { { vim.fn.getcwd() }, "filename" },
          lualine_x = {
            { "encoding" },
            { "filetype" },
            { "fileformat" },
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = fg("Statement"),
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = fg("Special"),
            },
          },
          lualine_y = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic", "nvim_lsp" },
              sections = { "error", "warn", "info", "hint" },
              diagnostics_color = {
                error = "DiagnosticError", -- Changes diagnostics' error color.
                warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
                info = "DiagnosticInfo", -- Changes diagnostics' info color.
                hint = "DiagnosticHint", -- Changes diagnostics' hint color.
              },
              symbols = {
                error = icons_d.Error,
                warn = icons_d.Warn,
                info = icons_d.Info,
                hint = icons_d.Hint,
              },
              colored = true, -- Displays diagnostics status in color if set to true.
              update_in_insert = false, -- Update diagnostics in insert mode.
              always_visible = false, -- Show diagnostics even if there are none.
              separator = { left = "" },
            },
            { "progress", separator = { left = "" } },
          },
        },
        inactive_sections = {
          lualine_a = {
            {
              window_num,
              separator = { right = "" },
              color = { fg = "white", bg = "grey" },
            },
          },
          lualine_c = {
            {
              "filename",
              color = { fg = "grey" },
            },
          },
          lualine_x = {
            {
              "location",
              color = { fg = "grey" },
            },
          },
        },
        extensions = {
          -- "nvim-tree",
          "symbols-outline",
          "fzf",
          "quickfix",
          "lazy",
          "nvim-dap-ui",
          "toggleterm",
          "trouble",
          "man",
          {
            sections = {
              lualine_a = {
                { window_num, separator = { right = "" }, color = { fg = "white", bg = "grey" } },
                {
                  function()
                    return [[File Explorer]]
                  end,
                  separator = { right = "" },
                },
              },
            },
            inactive_sections = {
              lualine_a = {
                { window_num, separator = { right = "" }, color = { fg = "white", bg = "grey" } },
              },
            },
            filetypes = { "NvimTree" },
          },
        },
      }
    end,
  },
}
