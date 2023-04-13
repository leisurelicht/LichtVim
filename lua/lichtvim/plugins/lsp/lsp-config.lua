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

-- 为 lsp hover 添加文件类型
local function lsp_hover(_, result, ctx, config)
  -- Add file type for LSP hover
  local bufnr, winner = vim.lsp.handlers.hover(_, result, ctx, config)
  if bufnr and winner then
    vim.api.nvim_buf_set_option(bufnr, "filetype", config.filetype)
    return bufnr, winner
  end
end

-- 为 lsp 签名帮助添加文件类型
local function lsp_signature_help(_, result, ctx, config)
  -- Add file type for LSP signature help
  local bufnr, winner = vim.lsp.handlers.signature_help(_, result, ctx, config)
  if bufnr and winner then
    vim.api.nvim_buf_set_option(bufnr, "filetype", config.filetype)
    return bufnr, winner
  end
end

local function list_or_jump(title)
  local api = vim.api
  local util = vim.lsp.util
  local log = require("vim.lsp.log")
  -- local pickers = require("telescope.pickers")
  -- local conf = require("telescope.config").values
  -- local finders = require("telescope.finders")
  -- local make_entry = require("telescope.make_entry")

  local handler = function(_, result, ctx, opts)
    if result == nil or vim.tbl_isempty(result) then
      local _ = log.info() and log.info(ctx.method, "No location found")
      return nil
    end
    local client = vim.lsp.get_client_by_id(ctx.client_id)

    opts = vim.tbl_deep_extend("force", { reuse_win = true }, opts or {})

    local res = {}
    if not vim.tbl_islist(result) then
      res = { result }
    end
    vim.list_extend(res, result)

    if #res == 0 then
      return
    elseif #res == 1 then
      -- location may be Location or LocationLink
      local uri = res[1].uri or res[1].targetUri
      if uri == nil then
        return
      end
      local bufnr = vim.uri_to_bufnr(uri)
      if not utils.buf.winid(bufnr) then
        if opts.jump_type == "tab" then
          vim.cmd("tabedit")
        elseif opts.jump_type == "split" then
          vim.cmd("new")
        elseif opts.jump_type == "vsplit" then
          vim.cmd("vnew")
        end
      end

      util.jump_to_location(res[1], client.offset_encoding, opts.reuse_win)
      return
    else
      local items = util.locations_to_items(res, client.offset_encoding)
      vim.fn.setqflist({}, " ", { title = title, items = items })
      api.nvim_command("botright copen")
      -- pickers
      --   .new(opts, {
      --     prompt_title = title,
      --     finder = finders.new_table({
      --       results = items,
      --       entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts),
      --     }),
      --     previewer = conf.qflist_previewer(opts),
      --     sorter = conf.generic_sorter(opts),
      --     push_cursor_on_edit = true,
      --     push_tagstack_on_edit = true,
      --     layout_config = {
      --       height = 0.7,
      --       width = 0.6,
      --     },
      --   })
      --   :find()
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
      {
        "folke/neoconf.nvim",
        enabled = false,
        cmd = "Neoconf",
        config = true,
      },
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return lazy.has("nvim-cmp")
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
      require("lichtvim.plugins.lsp.config.format").autoformat = opts.autoformat
      lazy.on_attach(function(client, buffer)
        if s_opts[client.name] ~= nil then
          local settings = s_opts[client.name].settings

          -- FIX: did not work
          if settings.document_formatting ~= nil then
            client.server_capabilities.document_formatting = settings.document_formatting
            client.server_capabilities.document_range_formatting = settings.document_formatting
          end

          if settings.formatting_on_save ~= nil and settings.formatting_on_save then
            require("lichtvim.plugins.lsp.config.format").on_attach(client, buffer)
          end
        end

        require("lichtvim.plugins.lsp.config.keymaps").on_attach(client, buffer)
      end)

      local function setup(server)
        if s_opts[server] == nil then
          -- vim.notify("LSP server [" .. server .. "] options not found")
          return
        end

        local options = s_opts[server].options
        local settings = s_opts[server].settings

        local handler = {
          ["textDocument/definition"] = list_or_jump("LSP Definitions"),
          ["textDocument/declaration"] = list_or_jump("LSP Declaration"),
          ["textDocument/typeDefinition"] = list_or_jump("LSP Type Definitions"),
          ["textDocument/implementation"] = list_or_jump("LSP Implementations"),
        }

        -- 设置浮动样式(兜底方案)
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

        if settings.document_diagnostics ~= nil and not settings.document_diagnostics then
          handler["textDocument/publishDiagnostics"] = function(...)
          end
          options.handlers = vim.tbl_deep_extend("force", handler, options.handlers or {})
        end
        options.handlers = vim.tbl_extend("force", lsp_handlers, options.handlers or {})

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        if lazy.has("cmp_nvim_lsp") then
          capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
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
}
