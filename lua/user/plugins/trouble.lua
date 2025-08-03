return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  config = function()
    local trouble = require("trouble")
    trouble.setup({})

    vim.keymap.set("n", "[t", function()
      trouble.open("diagnostics")
      trouble.prev({ skip_groups = true, jump = true, refresh = false })
    end, { desc = "Go to previous diagnostic message" })

    vim.keymap.set("n", "]t", function()
      trouble.open("diagnostics")
      trouble.next({ skip_groups = true, jump = true, refresh = false })
    end, { desc = "Go to next diagnostic message" })

    vim.keymap.set("n", "<leader>dq", function()
      trouble.toggle("diagnostics")
    end, { desc = "Open diagnostics list" })
  end,
}
