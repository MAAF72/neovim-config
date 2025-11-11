return {
  {
    "statusline",
    dir = vim.fn.stdpath("config") .. "/lua/custom/statusline",
    lazy = false,
    opts = {},
    config = function(_, opts)
      require("custom.statusline").setup(opts)
    end,
  },
  {
    "tabline",
    dir = vim.fn.stdpath("config") .. "/lua/custom/tabline",
    lazy = false,
    opts = {},
    config = function()
      require("custom.tabline").setup()
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          if vim.fn.isdirectory(data.file) == 0 then return end
          require("nvim-tree.api").tree.open()

          -- disable statusline in tree
          vim.wo.statusline = " "
        end,
      })
    end,
    opts = {
      sort = { sorter = "case_sensitive" },
      view = { width = 28 },
      renderer = {
        group_empty = true,
        root_folder_label = false,
        highlight_git = true,
      },
      filters = {
        dotfiles = false,
        git_ignored = false,
        custom = {
          "^\\.git$",
          "^\\.vscode$",
          "^\\.ccls-cache$",
        },
      },
      actions = {
        open_file = {
          quit_on_open = true,
        }
      }
    },
    keys = {
      { "<leader>e", "<Cmd>NvimTreeToggle<CR>", desc = "Toggle Tree" },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify"
    }
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    opts = {},
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "[F]ind [F]iles" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end,  desc = "[F]ind Live [G]rep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end,    desc = "[F]ind [B]uffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end,  desc = "Help" },
    }
  },
  {
    "numToStr/FTerm.nvim",
    cmd = "FTerm",
    opts = {},
    keys = {
      { '<leader>ftt', function() require("FTerm").toggle() end, desc = "[T]ogle [T]erminal" },
      { '<leader>fto', function() require('FTerm').open() end,   desc = "[T]erminal [O]pen" },
      { '<leader>fte', function() require('FTerm').exit() end,   desc = "[T]erminal [E]xit" },
      { '<leader>ftc', function() require('FTerm').close() end,  desc = "[T]erminal [C]lose" },
    }
  },
  {
    "folke/which-key.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps" }
    },
  },
}
