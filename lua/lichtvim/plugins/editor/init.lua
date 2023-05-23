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
    end,
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({})
    end,
  },
  {
    "dstein64/vim-startuptime",
    enabled = true,
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
  { "wakatime/vim-wakatime" },
}
