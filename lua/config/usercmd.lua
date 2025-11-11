vim.api.nvim_create_user_command("Bdelete", function()
  local is_last_buf = (#vim.fn.getbufinfo({ buflisted = 1 }) <= 1)
  local target_buf = vim.api.nvim_get_current_buf()

  -- Open nvim-tree first before deleting the last buffer to avoid nvim create unamed buffer
  if is_last_buf then
    pcall(vim.cmd, "NvimTreeOpen")
  end

  pcall(vim.cmd, "bdelete " .. target_buf)
end, {})