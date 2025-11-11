return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "vim",
        "regex",
        "lua",
        "bash",
        "diff",
        "sql",
        "python",
        "typescript", "javascript",
        "gitignore", "gitcommit", "gitattributes", "git_config", "git_rebase",
        "json", "yaml", "xml", "toml", 
        "html", "css",
        "markdown", "markdown_inline","comment",
        "go", "gomod", "gowork", "gosum",
        "c", "cpp",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      folds = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      enable = true,
      max_lines = 4,
      trim_scope = "outer",
      mode = "cursor",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "BufReadPost",
    opts = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["al"] = "@loop.outer",
          ["il"] = "@loop.inner",
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- create jumplist entries
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]c"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]C"] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[c"] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[C"] = "@class.outer",
        },
      },

      swap = {
        enable = true,
        swap_next = {
          ["]a"] = "@parameter.inner",
        },
        swap_previous = {
          ["[a"] = "@parameter.inner",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup({
        textobjects = opts,
      })
    end,
  }
}
