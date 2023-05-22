math.randomseed(os.time())

local function pick_color()
  local colors = { "String", "Identifier", "Keyword", "Number" }
  return colors[math.random(#colors)]
end

local function button(sc, txt, keybind, keybind_opts)
  local opts = {
    position = "center",
    shortcut = sc,
    cursor = 5,
    width = 50,
    align_shortcut = "right",
    hl = "Dashboard",
    hl_shortcut = "Keyword",
  }

  if keybind then
    keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
    opts.keymap = { "n", sc:gsub("%s", ""):gsub("SPC", "<leader>"), keybind, keybind_opts }
  end

  return {
    type = "button",
    val = txt,
    on_press = function()
      local key = vim.api.nvim_replace_termcodes(sc .. "<Ignore>", true, false, true)
      vim.api.nvim_feedkeys(key, "t", false)
    end,
    opts = opts,
  }
end

return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-web-devicons" },
    opts = {
      layout = {
        { type = "padding", val = 10 },
        {
          type = "text",
          val = {
            [[  ██╗     ██╗ ██████╗██╗  ██╗████████╗██╗   ██╗██╗███╗   ███╗ ]],
            [[  ██║     ██║██╔════╝██║  ██║╚══██╔══╝██║   ██║██║████╗ ████║ ]],
            [[  ██║     ██║██║     ███████║   ██║   ██║   ██║██║██╔████╔██║ ]],
            [[  ██║     ██║██║     ██╔══██║   ██║   ╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
            [[  ███████╗██║╚██████╗██║  ██║   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
            [[  ╚══════╝╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
          },
          opts = { position = "center", hl = pick_color() },
        },
        { type = "padding", val = 2 },
        {
          type = "text",
          val = function()
            local version = vim.version()
            return string.format(
              [[ Date %s |  Version %s.%s.%s |  Plugins %s]],
              os.date("%Y-%m-%d"),
              version.major,
              version.minor,
              version.patch,
              require("lazy").stats().count
            )
          end,
          opts = { position = "center", hl = "Number" },
        },
        { type = "padding", val = 2 },
        {
          type = "group",
          val = {
            button("e", "  New File", "<cmd>ene <cr>"),
            button("SPC f f", "  Find File"),
            button("SPC f j", "  Find Project"),
            button("SPC f o", "  Recently Opened Files"),
            button("q", "  Quit", "<cmd>confirm q<cr>"),
          },
          opts = { spacing = 1 },
        },
        { type = "padding", val = 2 },
        {
          type = "group",
          val = {

            { type = "text", val = "- Tools -", opts = { position = "center", hl = "Number" } },
            button("SPC p l", "󰒲  Lazy"),
            button("SPC p m", "  Mason"),
            button("SPC p t", "  Tressitter Update"),
          },
          opts = { spacing = 1 },
        },
        { type = "padding", val = 2 },
        { type = "text", val = " - LichtVim -", opts = { position = "center", hl = "Number" } },
      },
      opts = { margin = 5 },
    },
    init = function()
      vim.cmd([[ autocmd FileType alpha setlocal nofoldenable ]])
    end,
  },
}
