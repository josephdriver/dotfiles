local settings = require("custom.settings").get()
local ai = settings.ai or {}
local provider = ai.provider or "none"
local ghost_text = (ai.mode or "ghost_text") == "ghost_text"

vim.g.ai_cmp = not ghost_text

return {
  {
    "zbirenbaum/copilot.lua",
    enabled = provider == "copilot",
    cmd = "Copilot",
    event = "InsertEnter",
    build = ":Copilot auth",
    opts = function()
      local opts = vim.tbl_deep_extend("force", {
        suggestion = {
          enabled = ghost_text,
          auto_trigger = true,
          hide_during_completion = not ghost_text,
          keymap = {
            accept = false,
            next = "<M-]>",
            prev = "<M-[>",
          },
        },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          help = true,
        },
      }, ai.copilot or {})

      opts.suggestion = vim.tbl_deep_extend("force", {
        enabled = ghost_text,
        auto_trigger = true,
        hide_during_completion = not ghost_text,
      }, opts.suggestion or {})

      LazyVim.cmp.actions.ai_accept = function()
        if require("copilot.suggestion").is_visible() then
          LazyVim.create_undo()
          require("copilot.suggestion").accept()
          return true
        end
      end

      return opts
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.copilot = { enabled = false }
    end,
  },
  {
    "Exafunction/codeium.nvim",
    enabled = provider == "codeium",
    cmd = "Codeium",
    event = "InsertEnter",
    build = ":Codeium Auth",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      local opts = vim.tbl_deep_extend("force", {
        enable_cmp_source = not ghost_text,
        virtual_text = {
          enabled = ghost_text,
          default_filetype_enabled = true,
          key_bindings = {
            accept = false,
            next = "<M-]>",
            prev = "<M-[>",
          },
        },
      }, ai.codeium or {})

      opts.enable_cmp_source = not ghost_text
      opts.virtual_text = vim.tbl_deep_extend("force", {
        enabled = ghost_text,
      }, opts.virtual_text or {})

      LazyVim.cmp.actions.ai_accept = function()
        if require("codeium.virtual_text").get_current_completion_item() then
          LazyVim.create_undo()
          vim.api.nvim_input(require("codeium.virtual_text").accept())
          return true
        end
      end

      return opts
    end,
  },
}
