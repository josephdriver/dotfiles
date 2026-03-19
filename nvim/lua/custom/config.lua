local settings = require("custom.settings").get()
local keymap = vim.keymap.set


-- centre after half-page jumps
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- center after search
keymap("n", "n", "nzz")
keymap("n", "N", "Nzz")

--centre after jumping to marks 
keymap("n", "G", "Gzz")

-- keep cursor certnered when scrolling
keymap("n", "<C-f>", "<C-f>zz")
keymap("n", "<C-b>", "<C-b>zz")

vim.opt.scrolloff = 10
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
