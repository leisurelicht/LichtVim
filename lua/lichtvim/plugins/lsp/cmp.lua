return {
  {
    "hrsh7th/nvim-cmp",
    enabled = true,
    version = false,
    event = { "LspAttach", "InsertEnter" },
    dependencies = {
      "dcampos/nvim-snippy",
      "dcampos/cmp-snippy",
      "rafamadriz/friendly-snippets",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      { "tzachar/cmp-fuzzy-buffer", dependencies = { "tzachar/fuzzy.nvim" } },
    },
    opts = function()
      local has_words_before = function()
        local unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

      local cmp = require("cmp")
      local snippy = require("snippy")
      local context = require("cmp.config.context")
      local icons = require("lichtvim.config").icons
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
        snippet = {
          expand = function(args)
            require("snippy").expand_snippet(args.body)
          end,
        },
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
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
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
          { name = "snippy" },
          { name = "fuzzy_buffer" },
        }),
        sorting = {
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
        view = {
          entries = { name = "custom", selection_order = "top_down" },
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            if vim.tbl_contains({ "path" }, entry.source.name) then
              local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
              if icon then
                vim_item.kind = icon
                vim_item.kind_hl_group = hl_group
                return vim_item
              end
            end

            vim_item.menu = (function()
              local m = icons.sources[entry.source.name]
              if m == nil then
                m = "[" .. string.upper(entry.source.name) .. "]"
              end
              return m .. "  [" .. vim_item.kind .. "]"
            end)()

            if icons.kinds[vim_item.kind] then
              vim_item.kind = icons.kinds[vim_item.kind] .. " "
            end
            return vim_item
          end,
        },
        window = {
          completion = cmp.config.window.bordered({ col_offset = -4 }),
          documentation = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}
