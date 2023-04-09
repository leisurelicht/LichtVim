local sys = require("lichtvim.utils").sys
local path = require("lichtvim.utils").path

return {
  { "itchyny/vim-cursorword", event = { "BufNewFile", "BufRead" } }, -- 标注所有光标所在单词
  {
    "nacro90/numb.nvim",
    event = { "BufNewFile", "BufRead" },
    config = function()
      require("numb").setup()
    end,
  },
  {
    "phaazon/hop.nvim",
    enabled = true,
    event = { "BufRead", "BufNewFile" },
    config = function()
      local hop = require("hop")
      local directions = require("hop.hint").HintDirection

      hop.setup({ keys = "etovxqpdygfblzhckisuran" })

      map.set("", "f", function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
      end, "Jump forward", { remap = true })

      map.set("", "F", function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
      end, "Jump backward", { remap = true })

      map.set("", "t", function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
      end, "Jump forward", { remap = true })
      map.set("", "T", function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
      end, "Jump backward", { remap = true })

      map.set("n", "<leader>hw", "<cmd>HopWord<cr>", "Word")
      map.set("n", "<leader>hl", "<cmd>HopLine<cr>", "Line")
      map.set("n", "<leader>hc", "<cmd>HopChar1<cr>", "Char")
      map.set("n", "<leader>hp", "<cmd>HopPattern<cr>", "Pattern")
      map.set("n", "<leader>hs", "<cmd>HopLineStart<cr>", "Line start")
      map.set("n", "<leader>haw", "<cmd>HopWordMW<cr>", "Word")
      map.set("n", "<leader>hal", "<cmd>HopLineMW<cr>", "Line")
      map.set("n", "<leader>hac", "<cmd>HopChar1MW<cr>", "Char")
      map.set("n", "<leader>hap", "<cmd>HopPatternMW<cr>", "Pattern")
      map.set("n", "<leader>has", "<cmd>HopLineStartMW<cr>", "Line start")

      local wk_ok, wk = pcall(require, "which-key")
      if wk_ok then
        wk.register({
          h = { name = "+Hop" },
          ha = { name = "+All Windows" },
          mode = "n",
          prefix = "<leader>",
        })
      end
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    enabled = true,
    event = { "BufNewFile", "BufRead" },
    config = function()
      require("hlslens").setup()
      local kopts = { noremap = true, silent = true }
      map.set(
        "n",
        "n",
        [[<cmd>execute('normal! '.v:count1.'n')<cr><cmd>lua require('hlslens').start()<cr>]],
        "Next",
        kopts
      )
      map.set(
        "n",
        "N",
        [[<cmd>execute('normal! '.v:count1.'N')<cr><cmd>lua require('hlslens').start()<cr>]],
        "Prev",
        kopts
      )
      map.set("n", "*", [[*<cmd>lua require('hlslens').start()<cr>]], "Forward search", kopts)
      map.set("n", "#", [[#<cmd>lua require('hlslens').start()<cr>]], "Backward search", kopts)
      map.set("n", "g*", [[g*<cmd>lua require('hlslens').start()<cr>]], "Weak forward search", kopts)
      map.set("n", "g#", [[g#<cmd>lua require('hlslens').start()<cr>]], "Weak backward search", kopts)
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    event = { "BufRead", "BufNewFile" },
    opts = {
      ignored_filetypes = { "nofile", "quickfix", "prompt" },
      ignored_buftypes = { "NvimTree" },
      -- when moving cursor between splits left or right,
      -- place the cursor on the same row of the *screen*
      -- regardless of line numbers. False by default.
      -- Can be overridden via function parameter, see Usage.
      move_cursor_same_row = false,
      resize_mode = {
        silent = true,
        hooks = {
          on_enter = function()
            vim.notify("Entering Resize Mode. Welcome")
          end,
          on_leave = function()
            vim.notify("Exiting Resize Mode. Bye")
          end,
        },
      },
    },
    config = function(_, opts)
      require("smart-splits").setup(opts)
      map.set("n", "<leader>ur", function()
        require("smart-splits").start_resize_mode()
      end, "Resize Mode")
    end,
  },
  {
    "brglng/vim-im-select",
    event = { "BufNewFile", "BufRead" },
    config = function()
      vim.g.im_select_enable_focus_eventsF = 1
      if sys.IsMacOS() then
        api.autocmd({ "InsertLeave" }, {
          pattern = { "*" },
          command = "call system('im-select com.apple.keylayout.ABC')",
        })
        api.autocmd({ "cmdlineLeave" }, {
          pattern = { "*" },
          command = "call system('im-select com.apple.keylayout.ABC')",
        })
        api.autocmd({ "VimEnter" }, {
          pattern = { "*" },
          command = "call system('im-select com.apple.keylayout.ABC')",
        })
      end
      map.set("n", "<leader>ue", "<cmd>ImSelectEnable<cr>", "ImSelect Enable")
      map.set("n", "<leader>ud", "<cmd>ImSelectDisable<cr>", "ImSelect Disable")
    end,
  },
  {
    "karb94/neoscroll.nvim",
    enabled = false,
    event = { "BufNewFile", "BufRead" },
    config = function()
      require("neoscroll").setup({ easing_function = "quadratic" })
      local t = {}
      -- Syntax: t[keys] = {function, {function arguments}}
      -- Use the "sine" easing function
      t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "20", [['cubic']] } }
      t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "20", [['cubic']] } }
      -- Use the "circular" easing function
      t["<C-b>"] = {
        "scroll",
        { "-vim.api.nvim_win_get_height(0)", "true", "50", [['cubic']] },
      }
      t["<C-f>"] = {
        "scroll",
        { "vim.api.nvim_win_get_height(0)", "true", "50", [['cubic']] },
      }
      -- Pass "nil" to disable the easing animation (constant scrolling speed)
      t["<C-y>"] = { "scroll", { "-0.10", "false", "100", nil } }
      t["<C-e>"] = { "scroll", { "0.10", "false", "100", nil } }
      -- When no easing function is provided the default easing function (in this case "quadratic") will be used
      t["zt"] = { "zt", { "10" } }
      t["zz"] = { "zz", { "10" } }
      t["zb"] = { "zb", { "10" } }

      require("neoscroll.config").set_mappings(t)
    end,
  },
  {
    "mbbill/undotree",
    event = { "BufRead", "BufNewFile" },
    config = function()
      if sys.IsMacOS() and vim.fn.has("presistent_undo") then
        local undotree_dir = vim.fn.expand(path.join(vim.fn.stdpath("cache"), "undodir"))

        -- style: default 1, optional: 1 2 3 4
        vim.g.undotree_WindowLayout = 4
        -- auto focus default 0
        vim.g.undotree_SetFocusWhenToggle = 1

        if vim.fn.isdirectory(undotree_dir) then
          vim.fn.mkdir(undotree_dir, "p", 0777)
        end

        vim.o.undodir = undotree_dir
        vim.o.undofile = true
      end
      map.set("n", "<leader>uu", "<cmd>UndotreeToggle<cr>", "UndoTree")
    end,
  },
  {
    "windwp/nvim-spectre",
    -- stylua: ignore
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>fr",
        function()
          require("spectre").open()
        end,
        desc = "Replace in files (Spectre)",
      },
    },
  },
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
  { -- session management
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" } },
    -- stylua: ignore
    keys = {
      { "<leader>as", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>al", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>ad", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },

  -- {
  --   "ethanholz/nvim-lastplace",
  --   event = {"BufRead", "BufNewFile"},
  --   opts = {
  --     lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
  --     lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
  --     lastplace_open_folds = true
  --   }
  -- }
  -- {
  --   "ellisonleao/glow.nvim",
  --   ft = {"markdown"},
  --   config = function()
  --     require("glow").setup({style = "dark", border = "rounded", pager = true})
  --     api.autocmd({"FileType"}, {
  --       pattern = {"markdown"},
  --       callback = function()
  --         map.set("n", "<leader>r", "<cmd>Glow<cr>", "Run",
  --                 {buffer = vim.fn.bufnr()})
  --       end,
  --       group = api.augroup("runner", {clear = true})
  --     })
  --   end
  -- }
}
