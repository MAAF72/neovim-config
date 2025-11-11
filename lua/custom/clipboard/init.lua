local M = {}

-- Setup function: sets tabline and autocommands
function M.setup()
  vim.opt.clipboard = ""
  vim.g.clipboard = nil

  if vim.fn.has("wsl") == 1 then
    vim.g.clipboard = {
      name = "WSLClipboard",
      copy = {
        ["+"] = "clip.exe",
        ["*"] = "clip.exe",
      },
      paste = {
        ["+"] = "powershell.exe -NoProfile -Command \"Get-Clipboard -Raw\"",
        ["*"] = "powershell.exe -NoProfile -Command \"Get-Clipboard -Raw\"",
      },
      cache_enabled = 0,
    }
  elseif vim.fn.has("win32") == 1 then
    vim.g.clipboard = {
      name = "WindowsClipboard",
      copy = {
        ["+"] = "clip.exe",
        ["*"] = "clip.exe",
      },
      paste = {
        ["+"] = "powershell.exe -NoProfile -Command \"Get-Clipboard -Raw\"",
        ["*"] = "powershell.exe -NoProfile -Command \"Get-Clipboard -Raw\"",
      },
      cache_enabled = 0,
    }
  elseif vim.fn.has("mac") == 1 then
    vim.g.clipboard = {
      name = "macOSClipboard",
      copy = {
        ["+"] = "pbcopy",
        ["*"] = "pbcopy",
      },
      paste = {
        ["+"] = "pbpaste",
        ["*"] = "pbpaste",
      },
      cache_enabled = 0,
    }
  elseif vim.fn.executable("termux-clipboard-set") == 1 then
    vim.g.clipboard = {
      name = "TermuxClipboard",
      copy = {
        ["+"] = "termux-clipboard-set",
        ["*"] = "termux-clipboard-set",
      },
      paste = {
        ["+"] = "termux-clipboard-get",
        ["*"] = "termux-clipboard-get",
      },
      cache_enabled = 0,
    }
  end
end

return M