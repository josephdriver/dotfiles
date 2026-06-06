return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open Diff View" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close Diff View" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File History" },
      { "<leader>gF", "<cmd>DiffviewFileHistory<cr>", desc = "Repo File History" },
    },
    opts = {
      enhanced_diff_hl = true,
      use_icons = true,
    },
  },
}
