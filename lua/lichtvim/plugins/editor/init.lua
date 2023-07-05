local utils = require("lichtvim.utils")

return {
  { "nvim-lua/plenary.nvim", lazy = true },
  { import = "lichtvim.plugins.editor.treesitter" },
  { import = "lichtvim.plugins.editor.enhance" },
  { import = "lichtvim.plugins.editor.neo-tree" },
  { import = "lichtvim.plugins.editor.which-key" },
  { import = "lichtvim.plugins.editor.find" },
  {
    "mrjones2014/smart-splits.nvim",
    event = { "BufRead", "BufNewFile" },
    opts = {
      ignored_filetypes = { "nofile", "quickfix", "prompt", "alpha" },
      ignored_buftypes = { "NvimTree" },
      move_cursor_same_row = false,
      resize_mode = {
        silent = true,
        hooks = {
          on_enter = function()
            log.info("Entering Resize Mode. Welcome")
          end,
          on_leave = function()
            log.info("Exiting Resize Mode. Bye")
          end,
        },
      },
    },
    config = function(_, opts)
      require("smart-splits").setup(opts)
      map.set("n", "<leader>us", utils.func.call(require("smart-splits").start_resize_mode), "Enable resize mode")
      map.set("n", "<leader>uS", "<cmd>tabdo wincmd =<cr>", "Resume size")
    end,
  },
  {
    "brglng/vim-im-select",
    event = { "BufNewFile", "BufRead" },
    keys = {
      { "<leader>ui", "<cmd>ImSelectEnable<cr>", desc = "Enable imselect" },
      { "<leader>uI", "<cmd>ImSelectDisable<cr>", desc = "Disable imselect" },
    },
    config = function()
      vim.g.im_select_enable_focus_eventsF = 1
      if utils.sys.is_macos() or utils.sys.is_linux() then
        vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineEnter", "CmdlineLeave", "VimEnter" }, {
          group = vim.api.nvim_create_augroup(utils.title.add("Imselect"), { clear = true }),
          pattern = { "*" },
          command = "call system('im-select com.apple.keylayout.ABC')",
        })
      end
    end,
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTelescope", "TodoTrouble" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ft", "<cmd>TodoTelescope theme=ivy<cr>", desc = "Todo (Telescope)" },
    },
    config = function()
      require("todo-comments").setup({})
    end,
  },
}
