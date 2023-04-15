local sys = require("lichtvim.utils").sys
local path = require("lichtvim.utils").path

return {
  { "nvim-lua/plenary.nvim", lazy = true },
  { import = "lichtvim.plugins.editor.treesitter" },
  { import = "lichtvim.plugins.editor.enhance" },
  { import = "lichtvim.plugins.editor.neo-tree" },
  { import = "lichtvim.plugins.editor.which-key" },
  { import = "lichtvim.plugins.editor.toggleterm" },
  { import = "lichtvim.plugins.editor.telecope" },
  {
    "ahmedkhalf/project.nvim",
    opts = {
      manual_mode = true,
      detection_methods = { "pattern" },
      patterns = {
        ".git",
        "_darcs",
        ".hg",
        ".bzr",
        ".svn",
        "Makefile",
        "package.json",
        "go.mod",
        "requirements.txt",
        "pyproject.toml",
        "Cargo.toml",
      },
      ignore_lsp = { "dockerls", "null_ls", "copilot" },
      exclude_dirs = { "/", "~" },
      show_hidden = false,
      silent_chdir = false,
      scope_chdir = "tab",
      datapath = vim.fn.stdpath("data"),
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
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
    "nvimdev/dbsession.nvim",
    cmd = { "SessionSave", "SessionDelete", "SessionLoad" },
    opts = {
      auto_save_on_exit = true,
    },
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
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
}
