local format_patterns = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.css", "*.scss", "*.html" }

vim.g.autoformat = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

local ok, local_config = pcall(require, "custom.local")
if ok and type(local_config) == "table" then
  if local_config.autoformat ~= nil then
    vim.g.autoformat = local_config.autoformat
  end

  if type(local_config.format_patterns) == "table" then
    format_patterns = local_config.format_patterns
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = format_patterns,
  callback = function(args)
    require("conform").format({ bufnr = args.buf, async = false })
  end,
})
