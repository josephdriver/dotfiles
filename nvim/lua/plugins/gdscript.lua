return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      opts.servers = opts.servers or {}
      opts.servers.gdscript = {
        filetypes = { "gdscript" },
      }

      opts.setup = opts.setup or {}
      opts.setup.gdscript = function(_, server_opts)
        lspconfig.gdscript.setup(vim.tbl_deep_extend("force", server_opts, {
          cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
          root_dir = util.root_pattern("project.godot", ".git"),
          single_file_support = false,
        }))

        return true
      end
    end,
  },
}
