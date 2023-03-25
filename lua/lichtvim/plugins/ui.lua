return {
  {"nvim-tree/nvim-web-devicons", lazy = true}, -- 图标
  {"MunifTanjim/nui.nvim", lazy = true}, -- ui components
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = {"BufReadPre", "BufNewFile"},
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = {try_as_border = true}
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "NvimTree"
        },
        callback = function() vim.b.miniindentscope_disable = true end
      })
    end,
    config = function(_, opts) require("mini.indentscope").setup(opts) end
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {"MunifTanjim/nui.nvim", "rcarriga/nvim-notify"},
    opts = {
      routes = {{view = "notify", filter = {event = "msg_shownode"}}},
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true
        }
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false -- add a border to hover docs and signature help
      }
    },
    -- stylua: ignore
    keys = {
      {
        "<S-Enter>",
        function() require("noice").redirect(vim.fn.getcmdline()) end,
        mode = "c",
        desc = "Redirect Cmdline"
      },
      {
        "<leader>ul",
        function() require("noice").cmd("last") end,
        desc = "Noice Last Message"
      },
      {
        "<leader>uh",
        function() require("noice").cmd("history") end,
        desc = "Noice History"
      },
      {
        "<leader>ua",
        function() require("noice").cmd("all") end,
        desc = "Noice All"
      },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then return "<c-f>" end
        end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
        mode = {"i", "n", "s"}
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then return "<c-b>" end
        end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = {"i", "n", "s"}
      }
    }
  },
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>uc",
        function()
          require("notify").dismiss({silent = true, pending = true})
        end,
        desc = "Clear Notifications"
      }
    },
    opts = {
      timeout = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end
    },
    init = function()
      -- when noice is not enabled, install notify on VeryLazy
      local lazy = require("lichtvim.utils.lazy")
      if not lazy.has("noice.nvim") then
        lazy.on_very_lazy(function() vim.notify = require("notify") end)
      end
    end
  },
  { -- better vim.ui
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({plugins = {"dressing.nvim"}})
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({plugins = {"dressing.nvim"}})
        return vim.ui.input(...)
      end
    end
  },
  {
    "folke/trouble.nvim",
    cmd = {"TroubleToggle", "Trouble"},
    opts = {use_diagnostic_signs = true},
    keys = {
      {
        "<leader>ux",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        desc = "Document Diagnostics (Trouble)"
      },
      {
        "<leader>uX",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        desc = "Workspace Diagnostics (Trouble)"
      },
      {
        "<leader>uL",
        "<cmd>TroubleToggle loclist<cr>",
        desc = "Location List (Trouble)"
      },
      {
        "<leader>uQ",
        "<cmd>TroubleToggle quickfix<cr>",
        desc = "Quickfix List (Trouble)"
      },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({skip_groups = true, jump = true})
          else
            vim.cmd.cprev()
          end
        end,
        desc = "Previous trouble/quickfix item"
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({skip_groups = true, jump = true})
          else
            vim.cmd.cnext()
          end
        end,
        desc = "Next trouble/quickfix item"
      }
    }
  }

}
