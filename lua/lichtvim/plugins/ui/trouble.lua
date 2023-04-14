return {
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    dependencies = { "nvim-web-devicons" },
    opts = { use_diagnostic_signs = true },
    keys = {
      {
        "<leader>ux",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        desc = "Document Diagnostics (Trouble)",
      },
      {
        "<leader>uX",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        desc = "Workspace Diagnostics (Trouble)",
      },
      {
        "<leader>uL",
        "<cmd>TroubleToggle loclist<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>uQ",
        "<cmd>TroubleToggle quickfix<cr>",
        desc = "Quickfix List (Trouble)",
      },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },
}
