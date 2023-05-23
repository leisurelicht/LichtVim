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
          use_winbar = "smart",
          selection_chars = "ABFJDKSL;CMRUEIWOQP",
        },
      },
    },
    cmd = "Neotree",
    init = function()
      vim.g.neo_tree_remove_legacy_commands = true
    end,
    opts = {
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      source_selector = {
        winbar = true,
        statusline = true,
        content_layout = "center",
        sources = {
          { source = "filesystem", display_name = icons.get.FolderClosed .. " File" },
          { source = "git_status", display_name = icons.git.Logo .. " Git" },
          { source = "buffers", display_name = icons.get.DefaultFile .. " Bufs" },
        },
      },
      default_component_configs = {
        indent = { padding = 0, indent_size = 1 },
        icon = {
          folder_closed = icons.get.FolderClosed,
          folder_open = icons.get.FolderOpen,
          folder_empty = icons.get.FolderEmpty,
        },
        modified = { symbol = icons.get.FileModified },
        git_status = {
          symbols = {
            added = icons.git.Add,
            deleted = icons.git.Delete,
            modified = icons.git.Change,
            renamed = icons.git.Rename,
            untracked = icons.git.Untracked,
            ignored = icons.git.Ignored,
            unstaged = icons.git.Unstaged,
            staged = icons.git.Staged,
            conflict = icons.git.conflict,
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
  },
}
