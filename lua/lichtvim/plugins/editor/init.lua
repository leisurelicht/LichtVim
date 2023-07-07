local utils = require("lichtvim.utils")

return {
  { "nvim-lua/plenary.nvim", lazy = true },
  { import = "lichtvim.plugins.editor.treesitter" },
  { import = "lichtvim.plugins.editor.neo-tree" },
  { import = "lichtvim.plugins.editor.which-key" },
  { import = "lichtvim.plugins.editor.find" },
  { "itchyny/vim-cursorword", event = { "BufNewFile", "BufRead" } }, -- 标注所有光标所在单词
  { "karb94/neoscroll.nvim", lazy = true, config = true },
  { "echasnovski/mini.bufremove", lazy = true },
  { "junegunn/vim-easy-align", lazy = true },
  -- { "nacro90/numb.nvim", lazy = true, config = true },
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
          on_enter = utils.func.call(log.info, "Entering Resize Mode. Welcome"),
          on_leave = utils.func.call(log.info, "Exiting Resize Mode. Bye"),
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
    "folke/flash.nvim",
    event = { "BufRead", "BufNewFile" },
    opts = {
      modes = {
        char = {
          enabled = false,
        },
      },
    },
    config = function(_, opts)
      require("flash").setup(opts)

      local Config = require("flash.config")
      local Char = require("flash.plugins.char")
      for _, motion in ipairs({ "f", "t", "F", "T" }) do
        vim.keymap.set({ "n", "x", "o" }, motion, function()
          require("flash").jump(Config.get({
            mode = "char",
            search = {
              mode = Char.mode(motion),
              max_length = 1,
            },
          }, Char.motions[motion]))
        end)
      end
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    lazy = true,
    cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers" },
    config = function(_, opts)
      require("colorizer").setup(opts)
    end,
  },
}
