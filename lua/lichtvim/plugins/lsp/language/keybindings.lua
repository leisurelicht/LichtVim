-- =================
-- keybindings.lua --- lsp 快捷键
-- Author: MuCheng
-- =================
--
local lspsaga_ok, _ = pcall(require, "lspsaga")
local telescope_ok, _ = pcall(require, "telescope")
local wk_ok, wk = pcall(require, "which-key")

map.set("n", "<leader>lI", "<cmd>LspInstallInfo<cr>", "Install Info")
map.set("n", "<leader>lo", "<cmd>SymbolsOutline<cr>", "Open Outline")
if lspsaga_ok then
  map.set("n", "<leader>ll", "<cmd>Lspsaga show_line_diagnostics<cr>", "Line Diagnostic")
  map.set("n", "<leader>ln", "<cmd>Lspsaga diagnostic_jump_next<cr>", "Next Diagnostic")
  map.set("n", "<leader>lp", "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Previous Diagnostic")
  map.set("n", "<leader>]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", "Next Diagnostic Info")
  map.set("n", "<leader>[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Previous Diagnostic Info")
else
  map.set("n", "<leader>ll", "<cmd>lua vim.diagnostic.open_float()<cr>", "Line Diagnostic")
  map.set("n", "<leader>ln", "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Next Diagnostic")
  map.set("n", "<leader>lp", "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous Diagnostic")
  map.set("n", "<leader>]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic Info")
  map.set("n", "<leader>[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous Diagnostic Info")
end

if wk_ok then
  wk.register({
    l = { name = "+Lsp" },
  }, { mode = "n", prefix = "<leader>" })

  wk.register({
    l = { name = "+Lsp" },
  }, { mode = "v", prefix = "<leader>" })
end

local M = {}

M.register = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  map.set("n", "<leader>la", vim.lsp.buf.code_action, "Code Action", { buffer = bufnr })
  map.set("n", "<leader>lF", "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Code Format", { buffer = bufnr })
  map.set("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, "Add Folder", { buffer = bufnr })
  map.set("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, "Remove Folder", { buffer = bufnr })
  map.set(
    "n",
    "<leader>lwl",
    "<cmd>print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>",
    "List Folders",
    { buffer = bufnr }
  )

  if wk_ok then
    wk.register({
      lw = { name = "+WorkSpace" },
      ls = { name = "+Synbols" },
    }, { mode = "n", prefix = "<leader>" })
  end

  map.set("n", "<leader>lh", vim.lsp.buf.hover, "Hover", { buffer = bufnr })
  map.set("n", "<leader>lH", vim.lsp.buf.signature_help, "Signature Help", { buffer = bufnr })

  map.set("v", "<leader>lF", "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Code Foramt", { buffer = bufnr })
  --[[ map.set("v", "<leader>la", vim.lsp.buf.range_code_action, "Code Action", { buffer = bufnr }) ]]
  if lspsaga_ok then
    map.set("n", "<leader>lr", "<cmd>Lspsaga rename<cr>", "Rename", { buffer = bufnr })
    -- map.set("n", "<leader>lh", "<cmd>Lspsaga hover_doc<cr>", "Hover", { buffer = bufnr })
    -- map.set("n", "<leader>lH", "<cmd>Lspsaga signature_help<cr>", "Signature Help", { buffer = bufnr })
    map.set("n", "<leader>lD", "<cmd>Lspsaga preview_definition<cr>", "Preview Definition", { buffer = bufnr })

    map.set(
      "n",
      "<C-u>",
      "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>",
      "Scroll Up",
      { buffer = bufnr }
    )
    map.set(
      "n",
      "<C-f>",
      "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>",
      "Scroll Down",
      { buffer = bufnr }
    )
  else
    map.set("n", "<leader>lr", vim.lsp.buf.rename, "Rename", { buffer = bufnr })
  end

  if telescope_ok then
    map.set("n", "<leader>lf", "<cmd>Telescope lsp_references<cr>", "References", { buffer = bufnr })
    map.set("n", "<leader>ld", "<cmd>Telescope lsp_definitions theme=dropdown<cr>", "Definition", { buffer = bufnr })
    map.set("n", "<leader>lt", "<cmd>Telescope lsp_type_definitions<cr>", "Type Definition", { buffer = bufnr })
    map.set("n", "<leader>li", "<cmd>Telescope lsp_implementations<cr>", "Implementation", { buffer = bufnr })
    map.set("n", "<leader>lg", "<cmd>Telescope diagnostics theme=dropdown<cr>", "Diagnostic", { buffer = bufnr })
    map.set(
      "n",
      "<leader>lsd",
      "<cmd>Telescope lsp_document_symbols theme=dropdown<cr>",
      "Document",
      { buffer = bufnr }
    )
    map.set(
      "n",
      "<leader>lsw",
      "<cmd>Telescope lsp_workspace_symbols theme=dropdown<cr>",
      "WorkSpace",
      { buffer = bufnr }
    )
    map.set(
      "n",
      "<leader>lsy",
      "<cmd>Telescope lsp_dynamic_workspace_symbols theme=dropdown<cr>",
      "Dynamically",
      { buffer = bufnr }
    )
  else
    map.set("n", "<leader>lf", vim.lsp.buf.references, "References", { buffer = bufnr })
    map.set("n", "<leader>ld", vim.lsp.buf.definition, "Definition", { buffer = bufnr })
    map.set("n", "<leader>ll", vim.lsp.buf.type_definition, "Type Definition", { buffer = bufnr })
    map.set("n", "<leader>li", vim.lsp.buf.implementation, "Implementation", { buffer = bufnr })
    map.set("n", "<leader>lg", vim.diagnostic.setloclist, "Diagnostic", { buffer = bufnr })
  end

  -- map.set("i", "<c-j>", function()
  -- 	-- When the signature is visible, pressing <c-j> again will close the window
  -- 	local wins = vim.api.nvim_list_wins()
  -- 	for _, win_id in ipairs(wins) do
  -- 		local buf_id = vim.api.nvim_win_get_buf(win_id)
  -- 		local ft = vim.api.nvim_buf_get_option(buf_id, "filetype")
  -- 		if ft == "lsp-signature-help" then
  -- 			vim.api.nvim_win_close(win_id, false)
  -- 			return
  -- 		end
  -- 	end
  -- 	vim.lsp.buf.signature_help()
  -- end, "Toggle Signature help", { buffer = bufnr })
  map.set({ "i", "n" }, "<c-f>", function()
    local scroll_floating_filetype = { "lsp-signature-help", "lsp-hover" }
    -- 获取所有窗口
    local wins = vim.api.nvim_list_wins()

    for _, win_id in ipairs(wins) do
      -- 获取窗口中的 buffer
      local buf_id = vim.api.nvim_win_get_buf(win_id)
      -- 获取窗口 buffer 的文件类型
      local ft = vim.api.nvim_buf_get_option(buf_id, "filetype")

      -- 判定窗口文件类型是否是 lsp-signature-help 或者 lsp-hover
      if vim.tbl_contains(scroll_floating_filetype, ft) then
        -- 获取当前窗口高度
        local win_height = vim.api.nvim_win_get_height(win_id)
        -- 获取当前光标所在行
        local cursor_line = vim.api.nvim_win_get_cursor(win_id)[1]
        -- 获取当前窗口中总共有多少行
        ---@diagnostic disable-next-line: redundant-parameter
        local buf_total_line = vim.fn.line("$", win_id)
        -- 获取当前窗口中最后一行的行号
        ---@diagnostic disable-next-line: redundant-parameter
        local win_last_line = vim.fn.line("w$", win_id)

        -- 如果窗口文字总行数等于窗口高度，代表不可滚动
        if buf_total_line == win_height then
          vim.api.nvim_echo({ { "Can't scroll down", "MoreMsg" } }, false, {})
          return
        end

        -- 判定当前所在行是否小于窗口最后一行，如果是，则直接向下翻 1 页 + 5 行
        if cursor_line < win_last_line then
          vim.api.nvim_win_set_cursor(win_id, { win_last_line, 0 })
          -- 判定当前所在行 + 5 行是否大于窗口中总行数，如果大于则直接到最后一行
        elseif cursor_line + 5 > buf_total_line then
          vim.api.nvim_win_set_cursor(win_id, { win_last_line, 0 })
          -- 否则说明当前光标没有在第一屏，也不会越界，向下走 5 行即可
        else
          vim.api.nvim_win_set_cursor(win_id, { cursor_line + 5, 0 })
        end

        return
      end
    end
    -- 如果没有匹配到特定的浮动窗口，则执行默认的 <c-f> 命令
    local keybinding = "<c-f>"
    local key = vim.api.nvim_replace_termcodes(keybinding, true, false, true)
    vim.api.nvim_feedkeys(key, "n", true)
  end, "Scroll Down Floating Window", { buffer = bufnr })
  map.set({ "i", "n" }, "<c-u>", function()
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
          vim.api.nvim_echo({ { "Can't scroll up", "MoreMsg" } }, false, {})
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

    local keybinding = "<c-u>"
    local key = vim.api.nvim_replace_termcodes(keybinding, true, false, true)
    vim.api.nvim_feedkeys(key, "n", true)
  end, "Scroll Up Floating Window", { buffer = bufnr })
end

return M
