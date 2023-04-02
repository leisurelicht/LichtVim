return {
  {
    "nvim-cmp",
    dependencies = {
      { "tzachar/cmp-tabnine", build = "./install.sh" },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, 1, { name = "cmp_tabnine", group_index = 1 })
      table.insert(opts.sorting.comparators, #opts.sorting.comparators, require("cmp_tabnine.compare"))
    end,
  },
}
