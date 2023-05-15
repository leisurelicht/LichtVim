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

-- vim.api.nvim_create_autocmd("QuitPre", {
--   callback = function()
--     local invalid_win = {}
--     local wins = vim.api.nvim_list_wins()
--     for _, w in ipairs(wins) do
--       local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
--       if bufname:match("NvimTree_") ~= nil then
--         table.insert(invalid_win, w)
--       end
--     end
--     if #invalid_win == #wins - 1 then
--       -- Should quit, so we close all invalid windows.
--       for _, w in ipairs(invalid_win) do
--         vim.api.nvim_win_close(w, true)
--       end
--     end
--   end,
-- })

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

  vim.keymap.set("n", "P", function()
    local node = api.tree.get_node_under_cursor()
    print(node.absolute_path)
  end, opts("Print Node Path"))
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
      local icons = require("lichtvim.utils.ui.icons").diagnostics
      return {
        on_attach = on_attach,
        open_on_tab = false,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = { enable = true, update_root = true },
        diagnostics = {
          enable = true,
          show_on_dirs = true,
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
      }
    end,
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },
}
