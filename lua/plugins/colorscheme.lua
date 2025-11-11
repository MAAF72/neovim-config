return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      colors = {
        theme = {
          all = {
            ui = {
                bg_gutter = "none"
            }
          }
        }
      }
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd.colorscheme("kanagawa")
    end,
  },
}