local devicons = require('nvim-web-devicons')

-- Separator icons (like NvChad's statusline)
local sep_l = " "
local sep_r = " "

local M = {}

M.opts = {}

-- Mode - Get the current mode (Normal, Insert, etc.)
function M.mode()
  local mode_map = {
    n = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    V = "V-LINE",
    c = "COMMAND",
    R = "REPLACE",
    s = "SELECT",
    S = "S-LINE",
  }
  local mode = vim.api.nvim_get_mode().mode
  local mode_name = mode_map[mode] or mode

  return "%#StatusLineMode#" .. sep_l .. " " .. mode_name .. " " .. sep_r .. "%#StatusLineMode#"
end

-- File Icon and File Name
function M.file()
  local filename = vim.fn.expand('%:t')
  if filename == "" or filename:match "NvimTree" then
    return ""
  end

  local extension = vim.fn.expand('%:e')
  local icon = devicons.get_icon(filename, extension) or "󰈚"

  return table.concat({
    "%#StatusLineFile#" .. sep_l .. " " .. icon .. " ",
    filename .. (vim.bo.modified and "(⁕)" or ""),
    sep_r .. "%#StatusLineFile#"
  })
end

-- Git Branch (using gitsigns if available)
function M.git()
  local signs = vim.b.gitsigns_status_dict

  if not signs or not signs.head then
    return ""
  end

  local added = signs.added or 0
  local changed = signs.changed or 0
  local removed = signs.removed or 0

  return table.concat({
    "%#StatusLineGit#" .. sep_l .. "  " .. signs.head .. " ",
    added > 0 and ("%#GitSignsAdd#  " .. added .. " ") or "",
    changed > 0 and ("%#GitSignsChange#  " .. changed .. " ") or "",
    removed > 0 and ("%#GitSignsDelete#  " .. removed .. " ") or "",
    sep_r .. "%#StatusLineGit#"
  })
end

-- LSP Client
function M.lsp()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return "" end
  return "%#StatusLineLSP#" .. sep_l .. "   " .. clients[1].name .. " " .. sep_r .. "%#StatusLineLSP#"
end

-- Diagnostics (Errors and Warnings)
function M.diagnostics()
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  local infos = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

  return table.concat({
    "%#StatusLineDiagnostics#" .. sep_l,
    errors > 0 and ("%#DiagnosticError#  " .. errors .. " ") or "",
    warnings > 0 and ("%#DiagnosticWarn#  " .. warnings .. " ") or "",
    hints > 0 and ("%#DiagnosticHint# 󰛩 " .. hints .. " ") or "",
    infos > 0 and ("%#DiagnosticInfo# 󰋼 " .. infos .. " ") or "",
    sep_r .. "%#StatusLineDiagnostics#"
  })
end

-- Current Working Directory (CWD)
function M.cwd()
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t") -- Get the current folder name
  return "%#StatusLineCWD#" .. sep_l .. " 󰉋 " .. cwd .. " " .. sep_r .. "%#StatusLineCWD#"
end

-- Cursor Position (Line/Column)
function M.position()
  return "%#StatusLinePosition#" .. sep_l .. "  %l:%c " .. sep_r .. "%#StatusLinePosition#"
end

-- Final Statusline
function M.build()
  return table.concat({
    "%#StatusLine#",
    M.mode(),
    M.cwd(),
    -- M.file(),
    M.git(),
    "%=", -- Center section separator
    M.diagnostics(),
    M.lsp(),
    M.position(),
    "%#StatusLine#",
  })
end

-- Setup autocommands
function M.setup(opts)
  opts = opts or {}
  M.opts = vim.tbl_extend("force", M.opts, opts) -- merge options if needed

  vim.opt.laststatus = 3                         -- global statusline
  vim.opt.statusline = "%!v:lua.require'custom.statusline'.build()"
end

return M
