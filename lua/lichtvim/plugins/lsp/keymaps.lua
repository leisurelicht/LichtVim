local Keys = require("lazy.core.handler.keys")
local format = require("lichtvim.plugins.lsp.format").format
local list = require("lichtvim.utils").list

local M = {}

M._keys = nil

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

function M.get()
  if M._keys then
    return M._keys
  end

  M._keys = {
    { "<leader>lI", "<cmd>LspInfo<cr>", desc = "Info" },
    { "<leader>ln", M.diagnostic_goto(true), desc = "Next Diagnostic" },
    { "<leader>lp", M.diagnostic_goto(false), desc = "Prev Diagnostic" },
    { "]d", M.diagnostic_goto(true), desc = "Next Diagnostic" },
    { "[d", M.diagnostic_goto(false), desc = "Prev Diagnostic" },
    { "]e", M.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
    { "[e", M.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
    { "]w", M.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
    { "[w", M.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
    { "<leader>lF", format, desc = "Format Document", has = "documentFormatting" },
    { "<leader>lF", format, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
    { "<leader>lk", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
    { "<c-k>", vim.lsp.buf.signature_help, desc = "Signature Help", mode = "i", has = "signatureHelp" },
    { "<leader>lh", vim.lsp.buf.hover, desc = "Hover" },
    {
      "<leader>ll",
      vim.diagnostic.open_float,
      desc = "Line Diagnostic",
    },
    {
      "<leader>la",
      function()
        require("actions-preview").code_actions({
          context = {
            only = { "source" },
            diagnostics = {},
          },
        })
      end,
      mode = { "v", "n" },
      desc = "Code Action",
      has = "codeAction",
    },

    { "<leader>lo", "<cmd>SymbolsOutline<cr>", desc = "Open Outline" },
    {
      "<esc>",
      function()
        local wins = vim.api.nvim_list_wins()
        for _, win_id in ipairs(wins) do
          local buf_id = vim.api.nvim_win_get_buf(win_id)
          local ft = vim.api.nvim_buf_get_option(buf_id, "filetype")
          if ft == "lsp-signature-help" or ft == "lsp-hover" then
            vim.api.nvim_win_close(win_id, true)
            return
          end
        end
        local keybinding = "<esc>" -- 如果没有匹配到特定的浮动窗口，则执行默认的 <c-f> 命令
        local key = vim.api.nvim_replace_termcodes(keybinding, true, false, true)
        vim.api.nvim_feedkeys(key, "n", true)
      end,
      mode = { "n", "i" },
    },
    {
      "<c-f>",
      function()
        local scroll_floating_filetype = { "lsp-signature-help", "lsp-hover" }
        local wins = vim.api.nvim_list_wins() -- 获取所有窗口

        for _, win_id in ipairs(wins) do -- 获取窗口中的 buffer
          local buf_id = vim.api.nvim_win_get_buf(win_id) -- 获取窗口 buffer 的文件类型
          local ft = vim.api.nvim_buf_get_option(buf_id, "filetype")
          if vim.tbl_contains(scroll_floating_filetype, ft) then -- 判定窗口文件类型是否是 lsp-signature-help 或者 lsp-hover
            local win_height = vim.api.nvim_win_get_height(win_id) -- 获取当前窗口高度
            local cursor_line = vim.api.nvim_win_get_cursor(win_id)[1] -- 获取当前光标所在行
            local buf_total_line = vim.fn.line("$", win_id) -- 获取当前窗口中总共有多少行
            local win_last_line = vim.fn.line("w$", win_id) -- 获取当前窗口中最后一行的行号
            if buf_total_line == win_height then -- 如果窗口文字总行数等于窗口高度，代表不可滚动
              vim.api.nvim_echo({ { "Can't Scroll Down", "MoreMsg" } }, false, {})
              return
            end

            if cursor_line < win_last_line then -- 判定当前所在行是否小于窗口最后一行，如果是，则直接向下翻 1 页 + 5 行
              vim.api.nvim_win_set_cursor(win_id, { win_last_line, 0 })
            elseif cursor_line + 5 > buf_total_line then -- 判定当前所在行 + 5 行是否大于窗口中总行数，如果大于则直接到最后一行
              vim.api.nvim_win_set_cursor(win_id, { win_last_line, 0 })
            else -- 否则说明当前光标没有在第一屏，也不会越界，向下走 5 行即可
              vim.api.nvim_win_set_cursor(win_id, { cursor_line + 5, 0 })
            end

            return
          end
        end
        local keybinding = "<c-f>" -- 如果没有匹配到特定的浮动窗口，则执行默认的 <c-f> 命令
        local key = vim.api.nvim_replace_termcodes(keybinding, true, false, true)
        vim.api.nvim_feedkeys(key, "n", true)
      end,
      mode = { "n", "i", "s" },
      desc = "Scroll down",
    },
    {
      "<c-b>",
      function()
        local scroll_floating_filetype = { "lsp-signature-help", "lsp-hover" }
        local wins = vim.api.nvim_list_wins()

        for _, win_id in ipairs(wins) do
          local buf_id = vim.api.nvim_win_get_buf(win_id)
          local ft = vim.api.nvim_buf_get_option(buf_id, "filetype")

          if vim.tbl_contains(scroll_floating_filetype, ft) then
            local win_height = vim.api.nvim_win_get_height(win_id)
            local cursor_line = vim.api.nvim_win_get_cursor(win_id)[1]
            ---@diagnostic disable-next-line: redundant-parameter
            local buf_total_line = vim.fn.line("$", win_id)
            ---@diagnostic disable-next-line: redundant-parameter
            local win_first_line = vim.fn.line("w0", win_id)

            if buf_total_line == win_height then
              vim.api.nvim_echo({ { "Can't Scroll Up", "MoreMsg" } }, false, {})
              return
            end

            if cursor_line > win_first_line then
              vim.api.nvim_win_set_cursor(win_id, { win_first_line, 0 })
            elseif cursor_line - 5 < 1 then
              vim.api.nvim_win_set_cursor(win_id, { 1, 0 })
            else
              vim.api.nvim_win_set_cursor(win_id, { cursor_line - 5, 0 })
            end

            return
          end
        end

        local keybinding = "<c-b>"
        local key = vim.api.nvim_replace_termcodes(keybinding, true, false, true)
        vim.api.nvim_feedkeys(key, "n", true)
      end,
      mode = { "n", "i", "s" },
      desc = "Scroll up",
    },
  }

  if lazy.has("telescope.nvim") then
    local _keys = {
      { "<leader>lf", "<cmd>Telescope lsp_references<cr>", desc = "Goto References" },
      {
        "<leader>ld",
        "<cmd>Telescope lsp_definitions theme=dropdown<cr>",
        desc = "Goto Definition",
        has = "definition",
      },
      {
        "<leader>li",
        "<cmd>Telescope lsp_implementations<cr>",
        desc = "Goto Implementation",
        has = "implementation",
      },
      { "<leader>lt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto Type Definition" },
      { "<leader>lL", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostic" },
    }

    list.extend(M._keys, _keys)
  else
    local _keys = {
      { "<leader>lf", vim.lsp.buf.references, "References" },
      { "<leader>ld", vim.lsp.buf.definition, "Definition" },
      { "<leader>lt", vim.lsp.buf.type_definition, "Type Definition" },
      { "<leader>li", vim.lsp.buf.implementation, "Implementation", has = "implementation" },
      { "<leader>lg", vim.diagnostic.setloclist, "Diagnostic" },
    }
    list.extend(M._keys, _keys)
  end

  if lazy.has("inc-rename.nvim") then
    M._keys[#M._keys + 1] = {
      "<leader>lr",
      function()
        require("inc_rename")
        return ":IncRename " .. vim.fn.expand("<cword>")
      end,
      expr = true,
      desc = "Rename",
      has = "rename",
    }
  else
    M._keys[#M._keys + 1] = { "<leader>lr", vim.lsp.buf.rename, desc = "Rename", has = "rename" }
  end

  return M._keys
end

function M.on_attach(client, buffer)
  local keymaps = {}

  for _, value in ipairs(M.get()) do
    local keys = Keys.parse(value)
    if keys[2] == vim.NIL or keys[2] == false then
      keymaps[keys.id] = nil
    else
      keymaps[keys.id] = keys
    end
  end

  for _, keys in pairs(keymaps) do
    if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
      local opts = Keys.opts(keys)
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      map.set(keys.mode or "n", keys[1], keys[2], nil, opts)
    end
  end

  if lazy.has("which-key.nvim") then
    require("which-key").register({
      l = { name = "LSP" },
      mode = { "n", "v" },
      prefix = "<leader>",
    })
  end
end

return M
