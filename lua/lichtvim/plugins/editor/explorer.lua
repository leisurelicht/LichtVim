local function open_nvim_tree_dir(data)
  -- buffer is a directory
  local directory = require("lichtvim.utils").file.is_dir(data.file)

  if not directory then
    return
  end

  if directory then
    -- change to the directory
    vim.cmd.cd(data.file)
  end

  require("nvim-tree.api").tree.open()
end

api.autocmd({ "VimEnter" }, { group = api.augroup("explorer"), callback = open_nvim_tree_dir })

local function print_node_path(node)
  print(node.absolute_path)
end

return {
  {
    "nvim-tree/nvim-tree.lua",
    vertions = "nightly",
    dependencies = { "ahmedkhalf/project.nvim" },
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
    keys = { { "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Explorer" } },
    init = function()
      -- disable netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      -- set termguicolors to enable highlight groups
      vim.opt.termguicolors = true
    end,
    config = function()
      local tree_cb = require("nvim-tree.config").nvim_tree_callback
      local icons = require("lichtvim.utils.ui.icons").diagnostics
      require("nvim-tree").setup({
        open_on_tab = false,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = { enable = true, update_root = true },
        diagnostics = {
          enable = false,
          show_on_dirs = false,
          icons = {
            hint = icons.Hint,
            info = icons.Info,
            warning = icons.Warn,
            error = icons.Error,
          },
        },
        select_prompts = true,
        view = {
          centralize_selection = true,
          width = 30,
          signcolumn = "auto",
          mappings = {
            list = {
              { key = "p", action = "print_path", action_cb = print_node_path },
              { key = "s", cb = tree_cb("vsplit") },
              { key = "o", cb = tree_cb("split") },
              { key = "<C-o>", cb = tree_cb("system_open") },
            },
          },
          number = true,
          float = {
            enable = false,
            open_win_config = {
              border = "rounded",
              width = 35,
              height = 50,
            },
          },
        },
      })
    end,
  },
}
