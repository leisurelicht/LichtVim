-- 为 lsp hover 添加文件类型
---@return bufnr
---@return winner
local function lsp_hover(_, result, ctx, config)
  -- Add file type for LSP hover
  local bufnr, winner = vim.lsp.handlers.hover(_, result, ctx, config)
  if bufnr and winner then
    vim.api.nvim_buf_set_option(bufnr, "filetype", config.filetype)
    return bufnr, winner
  end
end

-- 为 lsp 签名帮助添加文件类型
---@return bufnr
---@return winner
local function lsp_signature_help(_, result, ctx, config)
  -- Add file type for LSP signature help
  local bufnr, winner = vim.lsp.handlers.signature_help(_, result, ctx, config)
  if bufnr and winner then
    vim.api.nvim_buf_set_option(bufnr, "filetype", config.filetype)
    return bufnr, winner
  end
end

local function lsmod(modname, fn)
  local root = require("lazy.core.util").find_root(modname)
  if not root then
    return
  end

  require("lichtvim.utils").path.ls(root, function(_, name, type)
    if (type == "file" or type == "link") and name:sub(-4) == ".lua" then
      fn(modname .. "." .. name:sub(1, -5), name:sub(1, -5))
    end
  end)
end

return {
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return lazy.has("nvim-cmp")
        end,
      },
      {
        "aznhe21/actions-preview.nvim",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-telescope/telescope.nvim" },
        config = function()
          require("actions-preview").setup({
            diff = {
              algorithm = "patience",
              ignore_whitespace = true,
            },
            telescope = require("telescope.themes").get_dropdown({ winblend = 10 }),
          })
        end,
      },
    },
    opts = {
      diagnostics = {
        signs = true,
        underline = true,
        severity_sort = true,
        update_in_insert = false,
        float = { source = "always" },
        virtual_text = { prefix = "●", source = "always" },
      },
      autoformat = true,
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      setup = {},
    },
    config = function(_, opts)
      for name, icon in pairs(require("lichtvim.utils.ui.icons").diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      vim.diagnostic.config(opts.diagnostics)

      local s_names = {}
      local s_opts = {}
      lsmod("lichtvim.plugins.lsp.servers", function(modname, name)
        s_names[#s_names + 1] = name
        s_opts[name] = require(modname)
      end)

      -- setup autoformat
      require("lichtvim.plugins.lsp.format").autoformat = opts.autoformat
      -- setup formatting and keymaps
      require("lichtvim.utils.lazy").on_attach(function(client, buffer)
        if s_opts[client.name] ~= nil and s_opts[client.name].on_attach ~= nil then
          s_opts[client.name].on_attach(client, buffer)
        end
        require("lichtvim.plugins.lsp.format").on_attach(client, buffer)
        require("lichtvim.plugins.lsp.keymaps").on_attach(client, buffer)
      end)

      -- 设置浮动样式
      local lsp_handlers = {
        ["textDocument/hover"] = vim.lsp.with(lsp_hover, {
          border = "rounded",
          filetype = "lsp-hover",
        }),
        ["textDocument/signatureHelp"] = vim.lsp.with(lsp_signature_help, {
          border = "rounded",
          filetype = "lsp-signature-help",
        }),
      }

      local function setup(server)
        local options = s_opts[server].options
        local settings = s_opts[server].settings

        if settings.document_diagnostics ~= nil and not settings.document_diagnostics then
          local handler = {
            ["textDocument/publishDiagnostics"] = function(...) end,
          }
          options.handlers = vim.tbl_deep_extend("force", handler, options.handlers or {})
        end
        options.handlers = vim.tbl_extend("force", lsp_handlers, options.handlers or {})

        options = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(
            require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
          ),
        }, options or {})

        if opts.setup[server] then
          if opts.setup[server](server, options) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, options) then
            return
          end
        end

        require("lspconfig")[server].setup(options)
      end

      local mlsp_ok, mlsp = pcall(require, "mason-lspconfig")
      if mlsp_ok then
        mlsp.setup({ ensure_installed = s_names })
        mlsp.setup_handlers({ setup })
      end
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        debug = false,
        sources = {
          nls.builtins.formatting.fish_indent,
          nls.builtins.diagnostics.fish,
          nls.builtins.formatting.stylua.with({
            "--indent-type=Spaces",
            "--indent-width=2",
          }),
          nls.builtins.formatting.shfmt,
          nls.builtins.diagnostics.flake8,
        },
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>um", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      ensure_installed = {
        "stylua",
        "shfmt",
        "flake8",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      local mr = require("mason-registry")

      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end

      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find("Windows"))
        and "echo -e 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
      or nil,
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    enabled = true,
    version = false,
    event = "InsertEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "onsails/lspkind-nvim",
      "lukas-reineke/cmp-under-comparator",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      { "tzachar/cmp-tabnine", build = "./install.sh" },
    },

    opts = function()
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local context = require("cmp.config.context")
      local suggestion = require("copilot.suggestion")
      return {
        enabled = function()
          -- disable completion in comments
          -- keep command mode completion enabled when cursor is in a comment
          if vim.api.nvim_get_mode().mode == "c" then
            return true
          else
            return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
          end
        end,
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
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
            if suggestion.is_visible() then
              suggestion.accept()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif cmp.visible() then
              cmp.select_next_item()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if suggestion.is_visible() then
              suggestion.dsmiss()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            elseif cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<cr>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          }),
        }),
        sources = cmp.config.sources({
          { name = "cmp_tabnine", group_index = 2 },
          { name = "nvim_lsp", group_index = 2 },
          { name = "luasnip", group_index = 2 },
          { name = "buffer", group_index = 2 },
          { name = "path", group_index = 2 },
        }),
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            require("cmp-under-comparator").under,
            require("cmp_tabnine.compare"),
            cmp.config.compare.kind,
            cmp.config.compare.locality,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        window = {
          completion = cmp.config.window.bordered({
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          }),
        },
        formatting = {
          fields = {
            "abbr",
            "kind",
            "menu",
          },
          format = require("lspkind").cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            symbol_map = require("lichtvim.utils.ui.icons").kind,
            before = function(entry, vim_item)
              vim_item.menu = (function()
                local m = require("lichtvim.utils.ui.icons").source[entry.source.name]
                if m == nil then
                  m = "[" .. string.upper(entry.source.name) .. "]"
                end
                return m
              end)()
              return vim_item
            end,
          }),
        },
        experimental = {
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
      }
    end,
    config = function(_, opts)
      Dump(opts)
      local cmp = require("cmp")
      cmp.setup(opts)

      cmp.event:on("menu_opened", function()
        vim.b.copilot_suggestion_hidden = true
      end)

      cmp.event:on("menu_closed", function()
        vim.b.copilot_suggestion_hidden = false
      end)

      -- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      -- local cmp = require("cmp")
      -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    opts = { show_numbers = true },
  },
}
