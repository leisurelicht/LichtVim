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
    init = function()
      vim.g.neo_tree_remove_legacy_commands = true
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
          { source = "filesystem", display_name = icons.file.FolderClosed .. " File" },
          { source = "git_status", display_name = icons.git.Logo .. " Git" },
          { source = "buffers", display_name = icons.file.DefaultFile .. " Bufs" },
        },
      },
      default_component_configs = {
        indent = {
          padding = 1,
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
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
    end,
  },
}
