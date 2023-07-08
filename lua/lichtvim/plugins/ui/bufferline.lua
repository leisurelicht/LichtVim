return {
  {
    "tiagovla/scope.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = { restore_state = false },
    config = function(_, opts)
      require("scope").setup(opts)
      -- require("telescope").load_extension("scope")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    opts = function()
      local icons = require("lichtvim.config").icons
      return {
        options = {
          numbers = "ordinal",
          separator_style = "thin",
          always_show_bufferline = false,
          hover = {
            enabled = true,
            delay = 200,
            reveal = { "close" },
          },
          indicator = { style = "underline" },
          close_command = function(n)
            require("mini.bufremove").delete(n, false)
          end,
          right_mouse_command = function(n)
            require("mini.bufremove").delete(n, false)
          end,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            return count > 0 and icons.diagnostics.Logo or nil
          end,
          offsets = {
            {
              filetype = "neo-tree",
              text = icons.file.FolderClosed .. " File Explorer",
              text_align = "center",
              separator = true,
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("bufferline").setup(opts)

      local utils = require("lichtvim.utils")
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup(utils.title.add("Keymap"), { clear = false }),
        pattern = { "*" },
        callback = function(event)
          local opt = { buffer = event.buf, silent = true }
          map.set("n", "<leader>bt", "<cmd>BufferLineTogglePin<CR>", "Toggle pin", opt)
          map.set("n", "<leader>bT", "<cmd>BufferLineGroupClose ungrouped<CR>", "Delete non-pinned buffers", opt)
          map.set("n", "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", "Previous buffer", opt)
          map.set("n", "<leader>bn", "<cmd>BufferLineCycleNext<cr>", "Next buffer", opt)
          map.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", "Previous buffer", opt)
          map.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", "Next buffer", opt)
          map.set("n", "<leader>bk", "<cmd>BufferLinePick<cr>", "Pick buffer", opt)
          map.set("n", "<leader>b1", "<cmd>BufferLineGoToBuffer 1<cr>", "Buffer 1", opt)
          map.set("n", "<leader>b2", "<cmd>BufferLineGoToBuffer 2<cr>", "Buffer 2", opt)
          map.set("n", "<leader>b3", "<cmd>BufferLineGoToBuffer 3<cr>", "Buffer 3", opt)
          map.set("n", "<leader>b4", "<cmd>BufferLineGoToBuffer 4<cr>", "Buffer 4", opt)
          map.set("n", "<leader>b5", "<cmd>BufferLineGoToBuffer 5<cr>", "Buffer 5", opt)
          map.set("n", "<leader>b6", "<cmd>BufferLineGoToBuffer 6<cr>", "Buffer 6", opt)
          map.set("n", "<leader>b7", "<cmd>BufferLineGoToBuffer 7<cr>", "Buffer 7", opt)
          map.set("n", "<leader>b8", "<cmd>BufferLineGoToBuffer 8<cr>", "Buffer 8", opt)
        end,
      })
    end,
  },
}
