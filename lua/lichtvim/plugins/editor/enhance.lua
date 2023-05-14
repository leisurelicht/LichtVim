return {
  { "yianwillis/vimcdoc", lazy = true },
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
    -- stylua: ignore
    config = function()
      local hop = require("hop")
      local directions = require("hop.hint").HintDirection

      hop.setup({ keys = "etovxqpdygfblzhckisuran" })

      map.set("", "f", function() hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true }) end, "Jump forward", { remap = true })
      map.set("", "F", function() hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true }) end, "Jump backward", { remap = true })
      map.set("", "t", function() hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 }) end, "Jump forward", { remap = true })
      map.set("", "T", function() hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 }) end, "Jump backward", { remap = true })

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
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    enabled = true,
    event = { "BufNewFile", "BufRead" },
    config = function()
      require("hlslens").setup()
      local kopts = { noremap = true, silent = true }
      -- stylua: ignore
      map.set( "n", "n", [[<cmd>execute('normal! '.v:count1.'n')<cr><cmd>lua require('hlslens').start()<cr>]], "Next", kopts )
      -- stylua: ignore
      map.set( "n", "N", [[<cmd>execute('normal! '.v:count1.'N')<cr><cmd>lua require('hlslens').start()<cr>]], "Prev", kopts )
      map.set("n", "*", [[*<cmd>lua require('hlslens').start()<cr>]], "Forward search", kopts)
      map.set("n", "#", [[#<cmd>lua require('hlslens').start()<cr>]], "Backward search", kopts)
      map.set("n", "g*", [[g*<cmd>lua require('hlslens').start()<cr>]], "Weak forward search", kopts)
      map.set("n", "g#", [[g#<cmd>lua require('hlslens').start()<cr>]], "Weak backward search", kopts)
    end,
  },
  {
    "karb94/neoscroll.nvim",
    event = { "BufNewFile", "BufRead" },
    opts = {
      easing_function = "quadratic",
    },
    config = function(_, opts)
      require("neoscroll").setup(opts)
      local t = {}
      -- Syntax: t[keys] = {function, {function arguments}}
      -- Use the "sine" easing function
      t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "20", [['cubic']] } }
      t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "20", [['cubic']] } }
      -- Use the "circular" easing function
      t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "50", [['cubic']] } }
      t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "50", [['cubic']] } }
      -- Pass "nil" to disable the easing animation (constant scrolling speed)
      t["<C-y>"] = { "scroll", { "-0.10", "false", "100", nil } }
      t["<C-e>"] = { "scroll", { "0.10", "false", "100", nil } }
      -- When no easing function is provided the default easing function (in this case "quadratic") will be used
      t["zt"] = { "zt", { "10" } }
      t["zz"] = { "zz", { "10" } }
      t["zb"] = { "zb", { "10" } }

      require("neoscroll.config").set_mappings(t)
      if lazy.has("which-key.nvim") then
        require("which-key").register({
          zt = { name = "Make cursor top" },
          zz = { name = "Make cursor medium" },
          zb = { name = "Make cursor bottom" },
          mode = "n",
        })
      end
    end,
  },
  {
    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
    },
  },
  {
    "junegunn/vim-easy-align",
    config = function()
      map.set({ "x", "n" }, "ga", "<Plug>(EasyAlign)", "EasyAlign", { noremap = false })
    end,
  },
}
