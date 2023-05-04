local function git_keymaps(gs, bufnr)
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
  map.set("n", "<leader>gb", function()
    gs.blame_line({ full = true })
  end, "Show blame line", { buffer = bufnr })
  map.set("n", "<leader>gd", gs.diffthis, "Diff this", { buffer = bufnr })
  map.set("n", "<leader>gD", function()
    gs.diffthis("~")
  end, "Diff this?", { buffer = bufnr })

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
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "!" },
          delete = { text = "-" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          git_keymaps(gs, bufnr)
        end,
      })
    end,
  },
}
