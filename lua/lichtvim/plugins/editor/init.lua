local sys = require("lichtvim.utils").sys
local path = require("lichtvim.utils").path

return {
  { "nvim-lua/plenary.nvim", lazy = true },
  { import = "lichtvim.plugins.editor.treesitter" },
  { import = "lichtvim.plugins.editor.enhance" },
  -- { import = "lichtvim.plugins.editor.nvim-tree" },
  { import = "lichtvim.plugins.editor.neo-tree" },
  { import = "lichtvim.plugins.editor.which-key" },
  { import = "lichtvim.plugins.editor.find" },
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
          -- stylua: ignore
          on_enter = function() vim.notify("Entering Resize Mode. Welcome") end,
          -- stylua: ignore
          on_leave = function() vim.notify("Exiting Resize Mode. Bye") end,
        },
      },
    },
    config = function(_, opts)
      require("smart-splits").setup(opts)
      map.set("n", "<leader>us", function()
        require("smart-splits").start_resize_mode()
      end, "Resize Mode")
      map.set("n", "<leader>uS", "<cmd>tabdo wincmd =<cr>", "Resume size")
    end,
  },
  {
    "brglng/vim-im-select",
    event = { "BufNewFile", "BufRead" },
    config = function()
      vim.g.im_select_enable_focus_eventsF = 1
      if sys.is_macos() or sys.is_linux() then
        vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineEnter", "CmdlineLeave", "VimEnter" }, {
          group = vim.api.nvim_create_augroup(add_title("imselect"), { clear = true }),
          pattern = { "*" },
          command = "call system('im-select com.apple.keylayout.ABC')",
        })
      end
      map.set("n", "<leader>ue", "<cmd>ImSelectEnable<cr>", "Enable imselect")
      map.set("n", "<leader>uE", "<cmd>ImSelectDisable<cr>", "Disable imselect")
    end,
  },
  {
    "folke/todo-comments.nvim",
    lazy = true,
    cmd = { "TodoTrouble" },
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({})
      if lazy.has("telescope.nvim") then
        map.set("n", "<leader>ft", "<cmd>TodoTelescope theme=ivy<cr>", "Todo")
      else
        map.set("n", "<leader>ft", "<cmd>TodoLocList<cr>", "Todo (LocList)")
      end
    end,
  },
  {
    "dstein64/vim-startuptime",
    enabled = false,
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
  { "wakatime/vim-wakatime" },
}
