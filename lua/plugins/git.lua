return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
    },
    keys = {
      { "<leader>gsd", ":Gitsigns preview_hunk<CR>", desc = "[G]it [S]ign [D]iff" },
    },
  },
  {
    -- Dont forget to install lazygit binary
    "kdheepak/lazygit.nvim",
    lazy = false,
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    keys = {
      { "<leader>lg", "<Cmd>LazyGit<CR>", desc = "[L]azy[G]it" }
    },
    config = function()
      require("telescope").load_extension("lazygit")
    end,
  },
}
