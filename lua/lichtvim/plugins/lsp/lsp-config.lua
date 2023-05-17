local icons = require("lichtvim.utils").icons

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

return {
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- stylua: ignore
      { "hrsh7th/cmp-nvim-lsp",              cond = function() return lazy.has("nvim-cmp") end },
      { "williamboman/mason-lspconfig.nvim", dependencies = { "mason.nvim" } },
      {
        "folke/neoconf.nvim",
        enabled = true,
        cmd = "Neoconf",
        config = true,
      },
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
    },
    opts = function()
      return {
        diagnostics = {
          signs = true,
          underline = true,
          severity_sort = true,
          update_in_insert = false,
          float = { source = "always" },
          virtual_text = { prefix = "icons", source = "if_many", spacing = 4 },
        },
        autoformat = true,
        format = { formatting_options = nil, timeout_ms = nil },
        setup = {},
        servers = {},
      }
    end,
    config = function(_, opts)
      for name, icon in pairs(icons.group("Diagnostics")) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
          or function(diagnostic)
            for d, icon in pairs(icons.group("Diagnostics")) do
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
          return
        end

        local options = s_opts[server].options
        local settings = s_opts[server].settings

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
          lsp_handlers["textDocument/publishDiagnostics"] = function(...) end
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
