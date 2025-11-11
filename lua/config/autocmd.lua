local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    local path = event.file or event.match
    if not path then return end

    -- Ignore URL-like buffer paths
    if path:match("^%w+://") then
      return
    end

    local file = vim.uv.fs_realpath(path) or path
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Set filetype for .env and .env.* files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("env_filetype"),
  pattern = { "*.env", ".env.*" },
  callback = function()
    vim.opt_local.filetype = "sh"
  end,
})

-- Set filetype for .yaml and .yaml.* files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("yaml_filetype"),
  pattern = { "*.yaml", ".yaml.*" },
  callback = function()
    vim.opt_local.filetype = "yaml"
  end,
})

-- Smart undo breakpoint
vim.api.nvim_create_autocmd({ "BufRead", "BufEnter" }, {
  group = augroup("smart_undo"),
  callback = function()
    vim.cmd("normal! gvgj:")  -- Create an undo break point
  end,
})