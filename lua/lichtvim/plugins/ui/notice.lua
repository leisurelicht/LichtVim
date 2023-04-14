return {
  {
    "folke/noice.nvim",
    enabled = function()
      return not vim.g.neovide
    end,
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      views = {
        split = {
          enter = true,
        },
      },
      -- TODO: 重定向 luv 配置询问窗口
      -- routes = {
      --   {
      --     filter = { find = "luv" },
      --     view = "split",
      --   },
      -- },
      commands = {
        history = {
          view = "split",
        },
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = true,
          view = "hover",
          opts = {
            border = "rounded",
          },
        },
        signature = {
          enabled = true,
          view = "hover",
          auto_open = {
            trigger = false,
          },
          opts = {
            border = "rounded",
          },
        },
      },
      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = false, -- 关闭搜索统计信息，用 hlslens 插件去做
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    config = function(_, opts)
      require("noice").setup(opts)

      map.set({ "n", "i", "s" }, "<c-f>", function()
        if not require("noice.lsp").scroll(4) then
          return "<c-f>"
        end
      end, "Next", { silent = true, expr = true })

      map.set({ "n", "i", "s" }, "<c-b>", function()
        if not require("noice.lsp").scroll(-4) then
          return "<c-b>"
        end
      end, "Previous", { silent = true, expr = true })
    end,
  },
}
