local utils = require("lichtvim.utils")

return {
  { "nvim-tree/nvim-web-devicons", lazy = true }, -- 图标
  { "MunifTanjim/nui.nvim", lazy = true },
  { import = "lichtvim.plugins.ui.alpha" },
  { import = "lichtvim.plugins.ui.lualine" },
  { import = "lichtvim.plugins.ui.bufferline" },
  { -- better notify
    "rcarriga/nvim-notify",
    keys = {
      { "<leader>fn", "<cmd>Telescope notify theme=dropdown<cr>", desc = "Notify" },
    },
    init = function()
      vim.notify = require("notify")
    end,
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    config = function(_, opts)
      require("notify").setup(opts)
      require("telescope").load_extension("notify")
      map.set(
        "n",
        "<leader>uq",
        utils.func.call(require("notify").dismiss, { silent = true, pending = true }),
        "Clear notifications"
      )
    end,
  },
  { -- better vim.ui
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
    opts = function()
      return {
        input = {
          relative = "cursor",
          win_options = { listchars = "precedes:❮,extends:❯" },
          mappings = { i = { ["<esc>"] = "close" } },
        },
        select = { backend = { "telescope", "nui" } },
      }
    end,
  },
  { -- better quickfix
    "folke/trouble.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = utils.func.call(vim.cmd.cprev)
            if not ok then
              log.warn(err)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = utils.func.call(vim.cmd.cnext)
            if not ok then
              log.warn(err)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
    opts = { use_diagnostic_signs = true },
  },
  { -- better statusline
    "luukvbaal/statuscol.nvim",
    event = "VeryLazy",
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        segments = {
          { text = { " ", builtin.lnumfunc }, click = "v:lua.ScLa" },
          { sign = { name = { "Git" }, maxwidth = 1, colwidth = 1, auto = false, wrap = false }, click = "v:lua.ScSa" },
          { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
        },
      })
    end,
  },
  { -- better fold
    "kevinhwang91/nvim-ufo",
    event = "VeryLazy",
    dependencies = "kevinhwang91/promise-async",
    opts = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" ... 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end

      return {
        fold_virt_text_handler = handler,
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
        open_fold_hl_timeout = 400,
        close_fold_kinds = { "imports", "comment" },
        preview = {
          win_config = {
            border = { "", "─", "", "", "", "─", "", "" },
            winblend = 0,
          },
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            jumpTop = "[",
            jumpBot = "]",
          },
        },
      }
    end,
    config = function(_, opts)
      require("ufo").setup(opts)
      map.set("n", "zR", require("ufo").openAllFolds, "Open all folds")
      map.set("n", "zM", require("ufo").closeAllFolds, "Close all folds")
      map.set("n", "zr", require("ufo").openFoldsExceptKinds, "Open folds except kinds")
      map.set("n", "zm", require("ufo").closeFoldsWith, "Close folds with") -- closeAllFolds == closeFoldsWith(0)
      map.set("n", "K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          -- vim.lsp.buf.hover()
          vim.cmd([[Lspsaga hover_doc]])
        end
      end, "Peek folded lines under cursor")
    end,
  },
}
