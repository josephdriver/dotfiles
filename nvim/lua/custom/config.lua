vim.g.autoformat = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

pcall(require, "custom.local")

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
  callback = function(args)
    require("conform").format({ bufnr = args.buf, async = false })
  end,
})
