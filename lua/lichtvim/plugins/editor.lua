local sys = require("lichtvim.utils").sys
local path = require("lichtvim.utils").path

return {
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
    cmd = { "PlenaryBustedFile", "PlenaryBustedDirectory" },
  },
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
    version = "v2",
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("hop").setup()
      map.set(
        "n",
        "f",
        "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
        "Jump Forward"
      )
      map.set(
        "n",
        "F",
        "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
        "Jump BackWard"
      )
      map.set(
        "o",
        "f",
        "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>",
        "Jump Forward"
      )
      map.set(
        "o",
        "F",
        "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>",
        "Jump BackWard"
      )
      map.set(
        "",
        "t",
        "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>",
        "Jump Forward"
      )
      map.set(
        "",
        "T",
        "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = -1 })<cr>",
        "Jump BackWard"
      )

      map.set("n", "<leader>hw", "<CMD>HopWord<CR>", "Word")
      map.set("n", "<leader>hl", "<CMD>HopLine<CR>", "Line")
      map.set("n", "<leader>hc", "<CMD>HopChar1<CR>", "Char")
      map.set("n", "<leader>hp", "<CMD>HopPattern<CR>", "Pattern")
      map.set("n", "<leader>hs", "<CMD>HopLineStart<CR>", "Line Start")
      map.set("n", "<leader>haw", "<CMD>HopWordMW<CR>", "Word")
      map.set("n", "<leader>hal", "<CMD>HopLineMW<CR>", "Line")
      map.set("n", "<leader>hac", "<CMD>HopChar1MW<CR>", "Char")
      map.set("n", "<leader>hap", "<CMD>HopPatternMW<CR>", "Pattern")
      map.set("n", "<leader>has", "<CMD>HopLineStartMW<CR>", "Line Start")

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
    event = { "BufNewFile", "BufRead" },
    keys = {
      {
        "n",
        desc = "Next Hlslens",
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
      },
      {
        "N",
        desc = "Previous Hlslens",
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
      },
      {
        "*",
        desc = "Forward Search",
        [[*<Cmd>lua require('hlslens').start()<CR>]],
      },
      {
        "#",
        desc = "Backward Search",
        [[#<Cmd>lua require('hlslens').start()<CR>]],
      },
      {
        "g*",
        desc = "Weak Forward Search",
        [[g*<Cmd>lua require('hlslens').start()<CR>]],
      },
      {
        "g#",
        desc = "Weak Backward Search",
        [[g#<Cmd>lua require('hlslens').start()<CR>]],
      },
    },
    config = function()
      require("hlslens").setup()
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
        api.autocmd({ "CmdlineLeave" }, {
          pattern = { "*" },
          command = "call system('im-select com.apple.keylayout.ABC')",
        })
        api.autocmd({ "VimEnter" }, {
          pattern = { "*" },
          command = "call system('im-select com.apple.keylayout.ABC')",
        })
      end
      map.set("n", "<leader>ue", "<CMD>ImSelectEnable<CR>", "ImSelect Enable")
      map.set("n", "<leader>ud", "<CMD>ImSelectDisable<CR>", "ImSelect Disable")
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
      map.set("n", "<leader>uu", "<CMD>UndotreeToggle<CR>", "UndoTree")
    end,
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
  --         map.set("n", "<leader>r", "<CMD>Glow<CR>", "Run",
  --                 {buffer = vim.fn.bufnr()})
  --       end,
  --       group = api.augroup("runner", {clear = true})
  --     })
  --   end
  -- }
}
