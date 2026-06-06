return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>fa",
        function()
          Snacks.picker.files({ hidden = true, ignored = true })
        end,
        desc = "Find All Files (Root Dir)",
      },
      {
        "<leader>sA",
        function()
          Snacks.picker.grep({ hidden = true, ignored = true })
        end,
        desc = "Grep All Files (Root Dir)",
      },
    },
  },
}
