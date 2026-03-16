vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.css", "*.scss", "*.html" },
  callback = function(args)
    require("conform").format({ bufnr = args.buf, async = false })
  end,
})
