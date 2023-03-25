return {
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
    cmd = {"PlenaryBustedFile", "PlenaryBustedDirectory"}
  },
  {"tpope/vim-surround", event = "InsertEnter"}, -- 快速修改
  {"itchyny/vim-cursorword", event = {"BufNewFile", "BufRead"}}, -- 标注所有光标所在单词
  {"norcalli/nvim-colorizer.lua", event = {"BufNewFile", "BufRead"}}, -- 颜色预览
  {"p00f/nvim-ts-rainbow", event = {"BufRead", "BufNewFile"}},
  { -- 自动配对
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {enable_check_bracket_line = false, ignored_next_char = "[%w%.]"}
  },
  {
    "andymass/vim-matchup",
    event = {"BufNewFile", "BufRead"},
    init = function()
      vim.g.matchup_matchparen_offscreen = {method = "poopup"}
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
