local utils = require("lichtvim.utils")

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

local function goto_definition(split_cmd)
  local util = vim.lsp.util
  local log = require("vim.lsp.log")
  local api = vim.api

  -- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
  local handler = function(_, result, ctx)
    -- Dump("ctx", ctx)
    -- Dump("result", result)
    if result == nil or vim.tbl_isempty(result) then
      local _ = log.info() and log.info(ctx.method, "No location found")
      return nil
    end

    if vim.tbl_islist(result) then
      res = result[1]
    else
      res = result
    end

    -- location may be Location or LocationLink
    local uri = res.uri or res.targetUri
    if uri == nil then
      return
    end
    local bufnr = vim.uri_to_bufnr(uri)

    if split_cmd and not utils.buf.winid(bufnr) then
      vim.cmd(split_cmd)
    end

    if vim.tbl_islist(result) then
      util.jump_to_location(res, "utf-8", true)

      if #result > 1 then
        util.set_qflist(util.locations_to_items(result))
        api.nvim_command("copen")
        api.nvim_command("wincmd p")
      end
    else
      util.jump_to_location(result, "utf-8", true)
    end
  end

  return handler
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
        virtual_text = { prefix = "●", source = "always", source = "always" },
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

      local function setup(server)
        local options = s_opts[server].options
        local settings = s_opts[server].settings

        local handler = {
          ["textDocument/definition"] = goto_definition("vsplit"),
        }
        if settings.document_diagnostics ~= nil and not settings.document_diagnostics then
          handler["textDocument/publishDiagnostics"] = function(...) end
        end
        options.handlers = vim.tbl_deep_extend("force", handler, options.handlers or {})

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        if lazy.has("cmp_nvim_lsp") then
          capabilities = vim.lsp.protocol.make_client_capabilities(capabilities)
        end
        options = vim.tbl_deep_extend("force", { capabilities = capabilities }, options or {})

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
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
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
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            require("cmp-under-comparator").under,
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
      local cmp = require("cmp")
      cmp.setup(opts)

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
