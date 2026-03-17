local settings = require("custom.settings").get()

vim.g.autoformat = settings.autoformat

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = settings.format_patterns,
  callback = function(args)
    require("conform").format({ bufnr = args.buf, async = false })
  end,
})
