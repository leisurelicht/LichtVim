-- 为 lsp hover 添加 filetype
local function lsp_hover(_, result, ctx, config)
  -- Add file type for LSP hover
  local bufnr, winner = vim.lsp.handlers.hover(_, result, ctx, config)
  if bufnr and winner then
    vim.api.nvim_buf_set_option(bufnr, "filetype", config.filetype)
    return bufnr, winner
  end
end

-- 为 lsp signature help 添加 filetype
local function lsp_signature_help(_, result, ctx, config)
  -- Add file type for LSP signature help
  local bufnr, winner = vim.lsp.handlers.signature_help(_, result, ctx, config)
  if bufnr and winner then
    vim.api.nvim_buf_set_option(bufnr, "filetype", config.filetype)
    return bufnr, winner
  end
end

-- 设置浮动窗口样式及 filetype
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

return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason-lspconfig.nvim", dependencies = { "mason.nvim" } },
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return require("lichtvim.utils.lazy").has("nvim-cmp")
        end,
      },
    },
    ---@class PluginLspOpts
    opts = function()
      return {
        -- options for vim.diagnostic.config()
        diagnostics = {
          signs = true,
          underline = true,
          severity_sort = true,
          update_in_insert = false,
          float = { source = "always" },
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "icons",
          },
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = false,
        },
        -- add any global capabilities here
        capabilities = {},
        -- Automatically format on save
        autoformat = true,
        -- Enable this to show formatters used in a notification
        -- Useful for debugging formatter issues
        format_notify = false,
        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` is handled by the LazyVim formatter,
        -- but can be also overridden when specified
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },

        -- LSP Server Settings
        servers = {},
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        setup = {
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
      }
    end,
    config = function(_, opts)
      local lazyUtils = require("lichtvim.utils.lazy")

      require("lichtvim.plugins.lsp.config.format").setup(opts)

      lazyUtils.on_attach(function(client, buffer)
        require("lichtvim.plugins.lsp.config.keymaps").on_attach(client, buffer)
      end)

      local register_capability = vim.lsp.handlers["client/registerCapability"]
      vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
        local ret = register_capability(err, res, ctx)
        local client_id = ctx.client_id
        ---@type lsp.Client
        local client = vim.lsp.get_client_by_id(client_id)
        local buffer = vim.api.nvim_get_current_buf()
        require("lichtvim.plugins.lsp.config.keymaps").on_attach(client, buffer)
        return ret
      end

      local icons = require("lichtvim.config").icons
      for name, icon in pairs(icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
      if opts.inlay_hints.enabled and inlay_hint then
        lazyUtils.on_attach(function(client, buffer)
          if client.server_capabilities.inlayHintProvider then
            inlay_hint(buffer, true)
          end
        end)
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
          or function(diagnostic)
            for d, icon in pairs(icons.diagnostics) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end
      end
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local s_names = {}
      local s_opts = {}
      for lsp_name, lsp_opts in pairs(opts.servers) do
        s_names[#s_names + 1] = lsp_name
        s_opts[lsp_name] = lsp_opts
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
      end
      capabilities = vim.tbl_deep_extend("force", capabilities, opts.capabilities or {})

      local function setup(server)
        local options = s_opts[server] or {}

        options.handlers = vim.tbl_extend("force", lsp_handlers, options.handlers or {})
        if options.disable_diagnostics ~= nil and options.disable_agnostics then
          options.handlers["textDocument/publishDiagnostics"] = function(...) end
        end

        options = vim.tbl_deep_extend("force", { capabilities = vim.deepcopy(capabilities) }, options)

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
        mlsp.setup({ ensure_installed = s_names, handlers = { setup } })
      end
    end,
  },
}
