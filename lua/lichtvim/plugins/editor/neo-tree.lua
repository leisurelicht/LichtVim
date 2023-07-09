local icons = require("lichtvim.config").icons

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      {
        "s1n7ax/nvim-window-picker",
        version = "v1.*",
        opts = {
          selection_chars = "ABFJDKSL;CMRUEIWOQP",
          use_winbar = "always",
          show_prompt = false,
        },
      },
    },
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = " Explorer" },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = true
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      source_selector = {
        winbar = true,
        statusline = false,
        content_layout = "center",
        sources = {
          { source = "filesystem", display_name = icons.file.FolderClosed .. "File" },
          { source = "git_status", display_name = icons.git.Logo .. "Git" },
          { source = "buffers", display_name = icons.file.DefaultFile .. "Bufs" },
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = icons.file.FolderClosed,
          folder_open = icons.file.FolderOpen,
          folder_empty = icons.file.FolderEmpty,
        },
        modified = { symbol = icons.file.FileModified },
        git_status = {
          symbols = {
            added = icons.git.Add,
            deleted = icons.git.Delete,
            modified = icons.git.Change,
            renamed = icons.git.Renamed,
            untracked = icons.git.Untracked,
            ignored = icons.git.Ignored,
            unstaged = icons.git.Unstaged,
            staged = icons.git.Staged,
            conflict = icons.git.Conflict,
          },
        },
      },
      window = {
        width = 35,
        mappings = {
          ["<space>"] = "none",
          ["S"] = "none",
          ["m"] = "none",
          -- [">"] = "none",
          -- ["<"] = "none",
          ["o"] = "split_with_window_picker",
          ["s"] = "vsplit_with_window_picker",
          ["<cr>"] = "open_with_window_picker",
          ["<tab>"] = { "toggle_preview", config = { use_float = true } },
          ["<esc>"] = "close_window",
        },
      },
      filesystem = {
        follow_current_file = true,
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
        always_show = { -- remains visible even if other settings would normally hide it
          ".gitignored",
        },
        never_show_by_pattern = { -- uses glob style patterns
          ".null-ls_*",
        },
      },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function(_)
            vim.opt_local.signcolumn = "auto"
          end,
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })

      vim.cmd([[delcommand Texplore]])
      vim.cmd([[delcommand Pexplore]])
    end,
  },
}
