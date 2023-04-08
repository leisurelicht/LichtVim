---@diagnostic disable: undefined-field, undefined-doc-name
return {
  {
    "nvim-cmp",
    dependencies = {
      {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
        config = function()
          require("cmp_tabnine.config").setup({
            max_lines = 1000,
            max_num_results = 20,
            sort = true,
            run_on_every_keystroke = false,
            show_prediction_strength = true,
            ignored_file_types = { TelescopePrompt = true },
          })
        end,
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, 1, { name = "cmp_tabnine", group_index = 1 })
      table.insert(opts.sorting.comparators, 1, require("cmp_tabnine.compare"))
    end,
  },
}
