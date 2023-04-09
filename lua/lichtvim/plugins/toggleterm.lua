function _G._Set_terminal_keymaps()
  map.set("t", "<SPACE><ESC>", [[<C-\><C-n>]], "Esc", { buffer = 0 })
  map.set("t", "<C-h>", [[<C-\><C-n><C-W>h]], "Up", { buffer = 0 })
  map.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], "Down", { buffer = 0 })
  map.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], "Left", { buffer = 0 })
  map.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], "Right", { buffer = 0 })
end

local function _smart_add_term()
  local direction = require("toggleterm.ui").guess_direction()

  if vim.b.toggle_number == nil then
    vim.notify("Create First Term Please")
    return
  end

  if direction == nil then
    if vim.g._term_direction == 1 then
      direction = "vertical"
    elseif vim.g._term_direction == 2 then
      direction = "horizontal"
    elseif vim.g._term_direction == 0 then
      vim.notify("Can Not Add Term Window", vim.log.levels.WARN)
      return
    end
  end

  if direction == "vertical" then
    vim.cmd("exe b:toggle_number+1.'ToggleTerm direction=vertical'")
    vim.g._term_direction = 1
  elseif direction == "horizontal" then
    vim.cmd("exe b:toggle_number+1.'ToggleTerm direction=horizontal'")
    vim.g._term_direction = 2
  end
end

local function _lazygit()
  require("toggleterm.terminal").Terminal
    :new({
      cmd = "lazygit",
      dir = "git_dir",
      direction = "float",
      float_opts = {
        border = "curved", -- 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
      },
      -- function to run on opening the terminal
      on_open = function(term)
        vim.cmd("startinsert!")
        map.set("n", "q", "<CScutD>close<CR>", "Close Lazygit", { buffer = term.bufnr, silent = true })
      end,
    })
    :toggle({})
end

local function _htop()
  require("toggleterm.terminal").Terminal:new({ cmd = "htop", hidden = true, direction = "float" }):toggle({})
end

local function _glow(file_name)
  local cmd = "glow " .. file_name .. "&& zsh"
  vim.notify(cmd)
  require("toggleterm.terminal").Terminal
    :new({
      cmd = cmd,
      hidden = false,
      direction = "float",
      close_on_exit = false,
      auto_scroll = false,
    })
    :toggle({})
end

return {
  "akinsho/toggleterm.nvim",
  cmd = "ToggleTerm",
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<C-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "curved", -- 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
      winblend = 0,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
    },
  },
  keys = function()
    -- TODO: 自动调用 glow 预览 markdown 文件
    -- api.autocmd({ "FileType" }, {
    --   group = api.augroup("Runner", { clear = true }),
    --   pattern = { "markdown" },
    --   callback = function()
    --     local file_name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
    --     map.set("n", "<leader>r", function()
    --       _glow(file_name)
    --     end, "Run", { buffer = vim.api.nvim_get_current_buf() })
    --   end,
    -- })

    return {
      { "<C-\\>", "<CMD>exe v:count1 . 'ToggleTerm'<CR>", desc = "Term Toggle" },
      -- { "<C-T>", "<CMD>exe v:count1 . 'ToggleTerm'<CR>", desc = "Term Toggle" },
      -- { "<C-T>", "<ESC><CMD>exe v:count1 . 'ToggleTerm'<CR>", desc = "Term Toggle" },
      { "<leader>of", "<CMD>ToggleTerm direction=float<CR>", desc = "Toggle In Float" },
      { "<leader>ot", "<CMD>ToggleTerm direction=tab<CR>", desc = "Toggle In Tab" },
      { "<leader>oh", "<CMD>ToggleTerm direction=horizontal<CR>", desc = "Toggle In Horizontal" },
      { "<leader>ov", "<CMD>ToggleTerm direction=vertical<CR>", desc = "Toggle In Vertical" },
      { "<leader>or", "<CMD>ToggleTermSendCurrentLine<CR>", desc = "Send Current Line" },
      { "<leader>or", "<CMD>ToggleTermSendVisualLines<CR>", desc = "Send Visual Lines" },
      { "<leader>os", "<CMD>ToggleTermSendVisualSelection<CR>", desc = "Send Visual Selection" },
      { "<leader>oa", _smart_add_term, desc = "Add New Term" },
      { "<leader>uh", _htop, desc = "Htop" },
      { "<leader>gl", _lazygit, desc = "Lazygit" },
    }
  end,

  config = function(_, opts)
    require("toggleterm").setup(opts)

    api.autocmd({ "TermOpen" }, {
      pattern = { "term://*" },
      command = "lua _Set_terminal_keymaps()",
    })
  end,
}
