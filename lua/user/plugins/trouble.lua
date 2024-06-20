return {
  "folke/trouble.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local trouble = require('trouble')
    trouble.setup({
      auto_refresh = false,
    })


    vim.keymap.set(
      'n',
      '[t',
      function()
        trouble.open("diagnostics")
        trouble.prev({ skip_groups = true, jump = true, refresh = false })
      end,
      { desc = 'Go to previous diagnostic message' }
    )

    vim.keymap.set(
      'n',
      ']t',
      function()
        trouble.open("diagnostics")
        trouble.next({ skip_groups = true, jump = true, refresh = false })
      end,
      { desc = 'Go to next diagnostic message' }
    )

    vim.keymap.set(
      'n',
      '<leader>dq',
      function()
        trouble.toggle("diagnostics")
      end,
      { desc = 'Open diagnostics list' }
    )
  end
}
