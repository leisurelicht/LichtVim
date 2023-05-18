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
        -- { "<leader>gl", _lazygit, desc = "Lazygit" },
      }
    end,
    config = function(_, opts)
      require("toggleterm").setup(opts)

      vim.api.nvim_create_autocmd({ "TermOpen" }, {
        group = vim.api.nvim_create_augroup(add_title("term_keymap"), { clear = true }),
        pattern = { "term://*" },
        callback = function()
          local opts = { buffer = 0 }
          map.set("t", "<space><esc>", [[<C-\><C-n>]], "Esc", opts)
          map.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], "Up", opts)
          map.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], "Down", opts)
          map.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], "Left", opts)
          map.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], "Right", opts)
          map.set("t", "<C-o>", _smart_add_term, "Add new terminal", opts)
          -- map.set("n", "<leader>oa", _smart_add_term, "Add new terminal", opts)
        end,
      })
    end,
  },
}
