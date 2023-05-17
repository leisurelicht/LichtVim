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

local function on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set("n", "t", api.node.open.tab, opts("Open: New Tab"))
  vim.keymap.set("n", "s", api.node.open.vertical, opts("Open: Vertical Split"))
  vim.keymap.set("n", "d", api.fs.trash, opts("Trash"))

  vim.keymap.set("n", "O", "", { buffer = bufnr })
  vim.keymap.del("n", "O", { buffer = bufnr })

  vim.keymap.set("n", "D", "", { buffer = bufnr })
  vim.keymap.del("n", "D", { buffer = bufnr })

  vim.keymap.set("n", "]d", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
  vim.keymap.set("n", "[d", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
  vim.keymap.set("n", "]e", "", { buffer = bufnr })
  vim.keymap.del("n", "]e", { buffer = bufnr })
  vim.keymap.set("n", "[e", "", { buffer = bufnr })
  vim.keymap.del("n", "[e", { buffer = bufnr })

  vim.keymap.set("n", "[g", api.node.navigate.git.prev, opts("Prev Git"))
  vim.keymap.set("n", "]g", api.node.navigate.git.next, opts("Next Git"))
  vim.keymap.set("n", "[c", "", { buffer = bufnr })
  vim.keymap.del("n", "[c", { buffer = bufnr })
  vim.keymap.set("n", "]c", "", { buffer = bufnr })
  vim.keymap.del("n", "]c", { buffer = bufnr })

  vim.keymap.set("n", "g?", "", { buffer = bufnr })
  vim.keymap.del("n", "g?", { buffer = bufnr })
  vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))

  vim.keymap.set("n", "<2-RightMouse>", "", { buffer = bufnr })
  vim.keymap.del("n", "<2-RightMouse>", { buffer = bufnr })
  vim.keymap.set("n", "<C-T>", "", { buffer = bufnr })
  vim.keymap.del("n", "<C-T>", { buffer = bufnr })
  vim.keymap.set("n", "<C-X>", "", { buffer = bufnr })
  vim.keymap.del("n", "<C-X>", { buffer = bufnr })
  vim.keymap.set("n", "<C-V>", "", { buffer = bufnr })
  vim.keymap.del("n", "<C-V>", { buffer = bufnr })
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
    opts = function()
      local icons = require("lichtvim.config").icons
      return {
        on_attach = on_attach,
        open_on_tab = false,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = { enable = true, update_root = true },
        diagnostics = {
          enable = true,
          show_on_dirs = true,
          show_on_open_dirs = false,
        },
        select_prompts = true,
        view = {
          centralize_selection = false,
          width = 35,
          signcolumn = "auto",
          number = false,
        },
        renderer = {
          indent_markers = {
            enable = true,
          },
          icons = {
            git_placement = "after",
            glyphs = {
              git = {
                unstaged = icons.git.Unstaged,
                staged = icons.git.Staged,
                unmerged = icons.git.Conflict,
                renamed = icons.git.Renamed,
                untracked = icons.git.Untracked,
                deleted = icons.git.Deleted,
                ignored = icons.git.Ignored,
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },
}
