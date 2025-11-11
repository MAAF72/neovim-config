local devicons = require('nvim-web-devicons')
local diagnostic = require('vim.diagnostic')

local M = {}

-- Get offset from nvim-tree
local function get_offset()
  local ok, view = pcall(require, "nvim-tree.view")
  if ok and view.is_visible() then
    local width = view.View.width or 0
    return string.rep(" ", width)
  end
  return ""
end

-- Get all listed buffers
local function buffer_list()
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })
  local tab_buffers = {}
  for _, buf in ipairs(bufs) do
    if vim.api.nvim_buf_is_loaded(buf.bufnr) then
      table.insert(tab_buffers, buf.bufnr)
    end
  end
  return tab_buffers
end

-- Build the tabline string
function M.tabline()
  local s = get_offset()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = buffer_list()

  for _, buf in ipairs(buffers) do
    local hl = (buf == current_buf) and "%#TabLineSel#▌" or "%#TabLine#"
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
    local extension = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":e")
    local modified = vim.api.nvim_buf_get_option(buf, "modified")

    local unsaved_mark = modified and " ●" or ""
    local icon = devicons.get_icon(name, extension) or "󰈚"

    if name == "" then
      name = "[no name]"
    end

    s = s .. hl .. "  " .. icon .. " " .. name .. unsaved_mark .. "  "
  end

  s = s .. "%#TabLineFill#"
  return s
end

-- Setup function: sets tabline and autocommands
function M.setup()
  vim.opt.showtabline = 2
  vim.opt.tabline = "%!v:lua.require'custom.tabline'.tabline()"

  -- Refresh tabline on buffer/window events
  vim.cmd [[
    augroup CustomTabline
      autocmd!
      autocmd BufAdd,BufDelete,BufEnter,WinEnter,WinLeave * redrawtabline
      autocmd FileType NvimTree redrawtabline
    augroup END
  ]]

  local hlTabLineSel = vim.api.nvim_get_hl_by_name("TabLineSel", true)

  vim.api.nvim_set_hl(0, "TabLineSel", {
    fg = hlTabLineSel.foreground,
    bg = hlTabLineSel.background,
  })
end

return M
