return {
  {
    "hrsh7th/nvim-cmp",
    enabled = true,
    version = false,
    event = "LspAttach",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "dcampos/nvim-snippy",
      "dcampos/cmp-snippy",
      "rafamadriz/friendly-snippets",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      {
        "tzachar/cmp-fuzzy-buffer",
        dependencies = {
          "tzachar/fuzzy.nvim",
        },
      },
    },
    opts = function()
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")
      local snippy = require("snippy")
      local context = require("cmp.config.context")
      local icons = require("lichtvim.utils.ui.icons")
      return {
        enabled = function()
          -- disable completion in comments
          -- keep command mode completion enabled when cursor is in a comment
          if vim.api.nvim_get_mode().mode == "c" then
            return true
          elseif vim.bo.filetype == "TelescopePrompt" then
            return false
          else
            return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
          end
        end,
        preselect = cmp.PreselectMode.None,
        experimental = {
          ghost_text = false, -- this feature conflict with copilot.vim's preview.
        },
        snippet = {
          expand = function(args)
            require("snippy").expand_snippet(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif snippy.can_expand_or_advance() then
              snippy.expand_or_advance()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          -- ["<CR>"] = cmp.mapping({
          --   i = function(fallback)
          --     if cmp.visible() and cmp.get_active_entry() then
          --       cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
          --     else
          --       fallback()
          --     end
          --   end,
          --   s = cmp.mapping.confirm({ select = false }),
          -- }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
          { name = "snippy" },
          { name = "fuzzy_buffer" },
        }),
        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            require("cmp_fuzzy_buffer.compare"),
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        formatting = {
          format = function(entry, item)
            local kinds = icons.kinds
            local sources = icons.sources
            if kinds[item.kind] then
              item.kind = kinds[item.kind] .. item.kind
            end
            item.menu = (function()
              local m = sources[entry.source.name]
              if m == nil then
                m = "[" .. string.upper(entry.source.name) .. "]"
              end
              return m
            end)()
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)

      cmp.setup.cmdline("/", {
        sources = cmp.config.sources({
          { name = "fuzzy_buffer" },
        }),
      })

      if lazy.has("copilot.lua") then
        local suggestion = require("copilot.suggestion")
        cmp.event:on("menu_opened", function()
          suggestion.dismiss()
          vim.b.copilot_suggestion_hidden = true
        end)

        cmp.event:on("menu_closed", function()
          vim.b.copilot_suggestion_hidden = false
        end)

        cmp.event:on("confirm_done", function()
          vim.b.copilot_suggestion_hidden = false
        end)
      end

      -- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      -- local cmp = require("cmp")
      -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}
