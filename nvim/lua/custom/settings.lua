local M = {}

local defaults = {
  autoformat = true,
  format_patterns = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.css", "*.scss", "*.html" },
  ai = {
    provider = "none",
    mode = "ghost_text",
    copilot = {},
    codeium = {},
  },
}

local settings = nil

function M.get()
  if settings then
    return settings
  end

  settings = vim.deepcopy(defaults)

  local ok, local_config = pcall(require, "custom.local")
  if ok and type(local_config) == "table" then
    settings = vim.tbl_deep_extend("force", settings, local_config)
  end

  return settings
end

return M
