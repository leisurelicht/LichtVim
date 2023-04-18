local function _smart_add_term()
  if vim.b.toggle_number == nil then
    vim.notify("Create A Terminal And Move In Please")
    return
  end

  local direction = require("toggleterm.ui").guess_direction()

  if direction == nil then
    if vim.g._term_direction == 1 then
      direction = "vertical"
    elseif vim.g._term_direction == 2 then
      direction = "horizontal"
    elseif vim.g._term_direction == 0 then
      vim.notify("Can Not Add A Terminal Window", vim.log.levels.INFO)
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
  {
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
      return {
        { "<C-\\>", "<CMD>exe v:count1 . 'ToggleTerm'<CR>", desc = "Toggle terminal" },
        { "<leader>of", "<CMD>ToggleTerm direction=float<CR>", desc = "Toggle in float" },
        { "<leader>ot", "<CMD>ToggleTerm direction=tab<CR>", desc = "Toggle in tab" },
        { "<leader>oh", "<CMD>ToggleTerm direction=horizontal<CR>", desc = "Toggle in horizontal" },
        { "<leader>ov", "<CMD>ToggleTerm direction=vertical<CR>", desc = "Toggle in vertical" },
        { "<leader>or", "<CMD>ToggleTermSendCurrentLine<CR>", desc = "Send current line" },
        { "<leader>or", "<CMD>ToggleTermSendVisualLines<CR>", desc = "Send visual lines" },
        { "<leader>os", "<CMD>ToggleTermSendVisualSelection<CR>", desc = "Send visual selection" },
        { "<leader>uh", _htop, desc = "Htop" },
        { "<leader>gl", _lazygit, desc = "Lazygit" },
      }
    end,

    config = function(_, opts)
      require("toggleterm").setup(opts)

      api.autocmd({ "TermOpen" }, {
        group = api.augroup("term_keymap"),
        pattern = { "term://*" },
        callback = function()
          local opts = { buffer = 0 }
          map.set("t", "<space><esc>", [[<C-\><C-n>]], "Esc", opts)
          map.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], "Up", opts)
          map.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], "Down", opts)
          map.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], "Left", opts)
          map.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], "Right", opts)
          map.set("t", "<C-n>", _smart_add_term, "Add new terminal", opts)
          map.set("n", "<leader>oa", _smart_add_term, "Add new terminal", opts)
        end,
      })

      -- TODO: 自动调用 glow 预览 markdown 文件
      -- api.autocmd({ "FileType" }, {
      --   group = api.augroup("Runner", { clear = true }),
      --   pattern = { "markdown" },
      --   callback = function()
      --     local buf = vim.api.nvim_get_current_buf()
      --     local file_name = vim.api.nvim_buf_get_name(buf)
      --     map.set("n", "<leader>r", function()
      --       _glow(file_name)
      --     end, "Run", { buffer = buf })
      --   end,
      -- })
    end,
  },
}
