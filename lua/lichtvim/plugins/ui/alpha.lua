math.randomseed(os.time())

local logo = {
  "      ░░                                                  ░░      ",
  "      ████                                              ████      ",
  "      ██▓▓██                                          ██  ██      ",
  "      ██▓▓▓▓██                                      ██    ██      ",
  "  ██████▓▓▓▓▓▓██████████████████████████████████████      ██████  ",
  "  ██░░░░░░▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░      ░░░░░░██  ",
  "  ██▓▓▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒      ▒▒▒▒▒▒  ██  ",
  "  ██▓▓▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒      ░░▒▒▒▒    ██  ",
  "  ██░░▓▓▓▓▒▒▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒    ░░██  ",
  "  ██░░▓▓▓▓▓▓▓▓▒▒▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒  ▒▒▒▒        ░░██  ",
  "  ██░░▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒        ▒▒░░██  ",
  "  ██▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▓▓▓▓▒▒▒▒▒▒░░▒▒▒▒▒▒    ▒▒▒▒        ▒▒▒▒  ██  ",
  "  ██▓▓▓▓▓▓▒▒▒▒▓▓▓▓▒▒▒▒▒▒▓▓▓▓▒▒▒▒░░▒▒▒▒    ▒▒▒▒▒▒    ▒▒▒▒      ██  ",
  "  ██░░▓▓▓▓▒▒▒▒▒▒▓▓▒▒▒▒▒▒▒▒▓▓▒▒▒▒░░▒▒    ░░▒▒  ▒▒  ░░▒▒      ░░██  ",
  "  ██▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒▓▓▒▒▒▒▒▒▓▓    ▒▒  ▒▒▒▒    ▒▒▒▒▒▒      ▒▒  ██  ",
  "  ██▓▓▓▓▒▒▓▓▓▓▓▓▒▒▒▒▓▓▓▓▓▓▒▒      ▒▒▒▒▒▒      ▒▒▒▒      ▒▒    ██  ",
  "  ██░░▓▓▓▓▒▒▒▒▓▓▒▒▓▓▒▒▒▒▓▓        ▒▒▒▒    ▒▒▒▒  ▒▒  ▒▒▒▒    ░░██  ",
  "  ██░░▓▓▓▓▓▓▓▓▒▒▒▒▓▓▒▒▒▒      ░░░░▒▒▒▒  ░░▒▒    ▒▒▒▒        ░░██  ",
  "  ██░░▒▒▓▓▓▓▓▓▓▓▒▒▒▒▓▓▓▓    ▒▒▒▒░░  ▒▒▒▒▒▒    ▒▒▒▒        ▒▒░░██  ",
  "  ██░░░░░░▓▓▓▓▓▓░░░░░░▓▓  ░░░░      ░░      ░░░░░░      ░░░░░░██  ",
  "  ██░░▒▒▒▒▒▒▓▓▓▓░░▒▒▒▒▒▒▒▒▒▒      ░░▒▒    ░░    ▒▒    ░░▒▒▒▒░░██  ",
  "  ██░░▓▓▓▓▒▒▒▒▓▓▒▒▓▓▓▓▓▓▒▒    ▒▒░░  ▒▒▒▒▒▒      ▒▒  ▒▒▒▒    ░░██  ",
  "  ██░░▒▒▓▓▓▓▓▓▒▒▒▒▒▒▓▓▓▓    ▒▒      ▒▒▒▒      ▒▒▒▒▒▒      ▒▒░░██  ",
  "  ██░░▒▒▓▓▓▓▓▓▓▓▒▒▓▓▒▒▓▓  ▒▒      ▒▒▒▒      ▒▒  ▒▒        ▒▒░░██  ",
  "  ██░░▒▒▒▒▒▒▓▓▓▓▒▒▓▓▓▓▒▒▒▒    ▒▒░░  ▒▒    ▒▒    ▒▒    ▒▒▒▒▒▒░░██  ",
  "  ██░░▒▒▓▓▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒  ▒▒      ▒▒▒▒▒▒      ▒▒▒▒▒▒▒▒  ▒▒░░██  ",
  "  ██░░▒▒▓▓▓▓▓▓▓▓▒▒▒▒▒▒▓▓  ▒▒      ▒▒▒▒      ▒▒▒▒▒▒        ▒▒░░██  ",
  "  ██░░▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒░░    ▒▒░░▒▒▒▒    ░░▒▒  ▒▒      ▒▒▒▒░░██  ",
  "  ██░░▒▒▒▒▒▒▒▒▓▓▒▒▓▓▓▓▓▓▒▒  ▒▒      ▒▒▒▒▒▒      ▒▒  ▒▒▒▒▒▒▒▒░░██  ",
  "  ██░░▒▒▒▒▓▓▓▓▒▒▒▒▒▒▓▓▓▓  ▒▒      ▒▒▒▒        ▒▒▒▒▒▒    ▒▒▒▒░░██  ",
  "  ██░░▒▒▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒░░  ▒▒▒▒░░▒▒▒▒    ░░▒▒▒▒      ░░▒▒▒▒░░██  ",
  "  ██░░▒▒▒▒▒▒▒▒▓▓▓▓▒▒▓▓▓▓  ▒▒▒▒      ▒▒▒▒▒▒    ▒▒    ▒▒▒▒▒▒▒▒░░██  ",
  "  ██░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒▒▒  ▒▒░░▒▒        ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░██  ",
  "  ██░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  ▒▒▒▒    ▒▒    ░░▒▒▒▒      ▒▒▒▒▒▒▒▒░░██  ",
  "  ██░░░░▒▒▒▒▒▒▒▒▓▓▓▓▒▒▒▒▒▒      ░░▒▒▒▒      ▒▒    ▒▒▒▒▒▒▒▒░░░░██  ",
  "  ██████░░░░▒▒▒▒▒▒▓▓▒▒▒▒    ▒▒▒▒░░        ▒▒▒▒  ▒▒▒▒▒▒░░░░██████  ",
  "        ████░░░░▒▒▒▒▒▒    ░░          ▒▒░░▒▒▒▒▒▒▒▒░░░░████        ",
  "            ████░░░░▒▒      ▒▒    ▒▒▒▒▓▓▓▓▓▓▒▒░░░░████            ",
  "                ██      ▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▓▓▓▓▓▓██                ",
  "              ██    ████░░░░▒▒▒▒░░▒▒▒▒░░░░████▓▓▓▓██              ",
  "            ██    ██    ████░░░░░░░░░░████    ██▓▓▓▓██            ",
  "          ████████          ████░░████          ████████          ",
  "                                ██                                ",
}

local function pick_color()
  local colors = { "String", "Identifier", "Keyword", "Number" }
  return colors[math.random(#colors)]
end

local function info()
  local total_plugins = require("lazy").stats().count
  local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
  local version = vim.version()
  local version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

  return datetime .. "   " .. total_plugins .. " plugins" .. version_info
end

local leader = "SPC"

local function button(sc, txt, keybind, keybind_opts)
  local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

  local opts = {
    position = "center",
    shortcut = sc,
    cursor = 5,
    width = 50,
    align_shortcut = "right",
    hl_shortcut = "Keyword",
  }
  if keybind then
    keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
    opts.keymap = { "n", sc_, keybind, keybind_opts }
  end

  local function on_press()
    local key = vim.api.nvim_replace_termcodes(sc .. "<Ignore>", true, false, true)
    vim.api.nvim_feedkeys(key, "t", false)
  end

  return { type = "button", val = txt, on_press = on_press, opts = opts }
end

return {
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-web-devicons" },
    opts = {
      layout = {
        { type = "padding", val = 1 },
        {
          type = "text",
          val = logo,
          opts = { position = "center", hl = pick_color() },
        },
        { type = "padding", val = 1 },
        {
          type = "text",
          val = info,
          opts = { position = "center", hl = "Number" },
        },
        { type = "padding", val = 1 },
        {
          type = "group",
          val = {
            button("e", "  New File", "<cmd>ene <cr>"),
            button("SPC f f", "  Find File"),
            button("SPC f o", "  Recently Opened Files"),
            button("SPC f w", "  Find Word"),
            button("SPC u p", "  Plugins", "<cmd>Lazy<cr>", { desc = "Lazy" }),
            button("q", "  Quit", "<cmd>confirm q<cr>"),
          },
          opts = { spacing = 1 },
        },
        { type = "padding", val = 1 },
        {
          type = "text",
          val = "- Licht -",
          opts = { position = "center", hl = "Number" },
        },
      },
      opts = { margin = 5 },
    },
    init = function()
      vim.cmd([[ autocmd FileType alpha setlocal nofoldenable ]])
    end,
  },
}
