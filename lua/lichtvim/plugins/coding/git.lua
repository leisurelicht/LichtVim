local path = require("lichtvim.utils").path

local function git_keymaps(bufnr)
  local gs = package.loaded.gitsigns
  map.set("n", "<leader>gB", "<cmd>GitBlameToggle<cr>", "Toggle line blame")
  map.set("n", "<leader>go", "<cmd>GitBlameOpenCommitURL<cr>", "Open commit url")
  map.set("n", "<leader>ga", gs.stage_hunk, "Add hunk", { buffer = bufnr })
  map.set("v", "<leader>ga", function()
    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, "Add hunk", { buffer = bufnr })
  map.set("n", "<leader>gr", gs.reset_hunk, "Reset hunk", { buffer = bufnr })
  map.set("v", "<leader>gr", function()
    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, "Reset hunk", { buffer = bufnr })
  map.set("n", "<leader>gA", gs.stage_buffer, "Add buffer", { buffer = bufnr })
  map.set("n", "<leader>gR", gs.reset_buffer, "Reset buffer", { buffer = bufnr })
  map.set("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk", { buffer = bufnr })
  map.set("n", "<leader>gp", gs.preview_hunk, "Preview hunk", { buffer = bufnr })
  map.set("n", "<leader>gt", gs.toggle_deleted, "Toggle deleted", { buffer = bufnr })
  -- stylua: ignore
  map.set("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Show blame line", { buffer = bufnr })
  map.set("n", "<leader>gd", gs.diffthis, "Diff this", { buffer = bufnr })
  -- stylua: ignore
  map.set("n", "<leader>gD", function() gs.diffthis("~") end, "Diff this?", { buffer = bufnr })

  map.set("n", "]g", function()
    if vim.wo.diff then
      return "]g"
    end
    vim.schedule(function()
      gs.next_hunk()
    end)
    return "<Ignore>"
  end, "Next git hunk", { buffer = bufnr, expr = true })

  map.set("n", "[g", function()
    if vim.wo.diff then
      return "[g"
    end
    vim.schedule(function()
      gs.prev_hunk()
    end)
    return "<Ignore>"
  end, "Previous git hunk", { buffer = bufnr, expr = true })
  map.set("n", "<leader>gg", function()
    require("lazy.util").float_term({ "lazygit" }, { border = "rounded", cwd = path.git_dir() })
  end, "Lazygit", { buffer = bufnr })
  map.set("n", "<leader>gl", function()
    require("lazy.util").float_term({ "lazygit", "log" }, { border = "rounded", cwd = path.git_dir() })
  end, "Lazygit log", { buffer = bufnr })

  -- Text object
  map.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<cr>")
end

return {
  {
    "f-person/git-blame.nvim",
    event = { "BufRead", "BufNewFile" },
    init = function()
      vim.g.gitblame_enabled = 0
    end,
    config = function() end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufRead", "BufNewFile" },
    dependencies = { "f-person/git-blame.nvim" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "!" },
        delete = { text = "-" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        -- git_keymaps(gs, bufnr)
        vim.api.nvim_command("doautocmd User Git")
      end,
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
  },
}
