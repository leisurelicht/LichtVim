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
      -- when noice is not enabled, install notify on VeryLazy
      local lazy = require("lichtvim.utils.lazy")
      if not lazy.has("noice.nvim") then
        lazy.on_very_lazy(function()
          vim.notify = require("notify")
        end)
      end
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
    opts = function()
      local builtin = require("statuscol.builtin")
      return {
        ft_ignore = { "neo-tree", "neo-tree-popup", "alpha", "lazy" },
        segments = {
          { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
          { sign = { name = { "Git" }, maxwidth = 1, colwidth = 1, auto = false, wrap = false }, click = "v:lua.ScSa" },
          { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
        },
      }
    end,
    config = function(_, opts)
      require("statuscol").setup(opts)
    end,
  },
  { -- better fold
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    init = function()
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
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
        provider_selector = function()
          return { "treesitter", "indent" }
        end,
        open_fold_hl_timeout = 400,
        close_fold_kinds = { "imports", "comment" },
        preview = {
          win_config = { border = { "", "─", "", "", "", "─", "", "" }, winblend = 0 },
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
          vim.lsp.buf.hover()
        end
      end, "Peek folded lines under cursor")
    end,
  },
  {
    "folke/noice.nvim",
    cond = function()
      return not require("lichtvim.utils").sys.is_neovide()
    end,
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = { enabled = true },
        signature = { enabled = true },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        command_palette = true,
        lsp_doc_border = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
    },
  },
  { -- lsp progress
    "j-hui/fidget.nvim",
    cond = function()
      return require("lichtvim.utils").sys.is_neovide()
    end,
    tag = "legacy",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      window = {
        relative = "editor",
      },
    },
    config = true,
  },
}
