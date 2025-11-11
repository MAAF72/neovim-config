return {
  {
    "clipboard",
    dir = vim.fn.stdpath("config") .. "/lua/custom/clipboard",
    lazy = false,
    opts = {},
    config = function()
      require("custom.clipboard").setup()
    end,
  },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = {
          enabled = true,
        }
      }
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump({ label = { after = { 0, 3 }, style = "inline" } }) end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,                                             desc = "Flash Treesitter" },
      { "r", mode = "o",               function() require("flash").remote() end,                                                 desc = "Remote Flash" },
      { "R", mode = { "o", "x" },      function() require("flash").treesitter_search() end,                                      desc = "Treesitter Search" },
      -- { "<C-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  }
  -- {
  --   "nvim-focus/focus.nvim",
  --   opts = {},
  -- }
}
