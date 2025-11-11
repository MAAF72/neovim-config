return {
  -- dont forget to install the required lsp tools
  -- you can use `go install golang.org/x/tools/...@latest`
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
    },
    lazy = false,
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              gofumpt = true,
              staticcheck = true,
            }
          }
        },
        ccls = (function()
          local compilers = { "gcc", "g++", "clang", "clang++" }
          local drivers = {}
          for _, c in ipairs(compilers) do
            local p = vim.fn.exepath(c)
            if p ~= nil and p ~= "" then
              table.insert(drivers, p)
            end
          end

          local extraArgs = {
            "--query-driver=" .. table.concat(drivers, ";"),
            "-std=c++11",
          }

          if vim.loop.os_uname().sysname == "Darwin" then
            local sdk_root = vim.fn.trim(vim.fn.system("xcrun --show-sdk-path 2>/dev/null"))
            if sdk_root ~= "" then
              table.insert(extraArgs, "-I" .. sdk_root .. "/usr/include")
              table.insert(extraArgs, "-I" .. sdk_root .. "/usr/include/c++/v1")
            end

            table.insert(extraArgs, "-stdlib=libc++")
          else
            table.insert(extraArgs, "-stdlib=libstdc++")
          end

          return {
            init_options = {
              index = {
                threads = 0,
              },
              clang = {
                extraArgs = extraArgs,
              },
            }
          }
        end)(),
        ts_ls = {},
      }
    },
    config = function(_, opts)
      -- Enable diagnostics globally
      vim.diagnostic.config({ virtual_text = true, signs = true })
      vim.diagnostic.enable()

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Setup each server
      for server, config in pairs(opts.servers) do
        config.capabilities = capabilities
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      -- Keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_keymap", { clear = true }),
        callback = function(event)
          local map = function(mode, keys, func, desc)
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("n", "grd", vim.lsp.buf.definition, "Go To Definition")
          map("n", "grt", vim.lsp.buf.type_definition, "Go To Type Definition")
          map("n", "gri", vim.lsp.buf.implementation, "Go To Implementation")
          map("n", "grr", vim.lsp.buf.references, "Go To References")
          map("n", "gra", vim.lsp.buf.code_action, "Open Code Action")
          map("n", "grn", vim.lsp.buf.rename, "Code Rename")
        end,
      })

      -- Auto save hook
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("lsp_formatting", { clear = true }),
        callback = function()
          local ft = vim.bo.filetype

          -- Go: format + organize imports
          -- Ref: https://go.dev/gopls/editor/vim#neovim-imports
          if ft == "go" then
            local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
            params.context = { only = { "source.organizeImports" } }
            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
            for cid, res in pairs(result or {}) do
              for _, r in pairs(res.result or {}) do
                if r.edit then
                  local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                  vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
              end
            end
          end

          -- Format for all languages that support it
          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP source
      "hrsh7th/cmp-buffer",   -- buffer completions
      "hrsh7th/cmp-path",     -- path completions
    },
    enable = false,
    event = "InsertEnter",
    opt = true,
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-o>"] = cmp.mapping.complete(),
          ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<Esc>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true, callback = function() vim.cmd("normal! gvgj:") end }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })

      cmp.setup.cmdline('/', { sources = { { name = "buffer" } } })
      cmp.setup.cmdline(':', { sources = { { name = "path" }, { name = "cmdline" } } })
    end,
  },
}
