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

return {
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason-lspconfig.nvim", dependencies = { "mason.nvim" } },
      { "folke/neodev.nvim", enabled = false, opts = {} },
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return lazy.has("nvim-cmp")
        end,
      },
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
        setup = {},
        servers = {},
      }
    end,
    config = function(_, opts)
      local icons = require("lichtvim.config").icons

      for name, icon in pairs(icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
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

      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities(),
        opts.capabilities or {}
      )

      local function setup(server)
        local options = s_opts[server]

        options = options or {}

        if options.disable_diagnostics ~= nil and options.disable_agnostics then
          lsp_handlers["textDocument/publishDiagnostics"] = function(...) end
        end

        options.handlers = vim.tbl_extend("force", lsp_handlers, options.handlers or {})

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
