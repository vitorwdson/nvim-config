return {
  "folke/trouble.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local trouble = require('trouble')
    trouble.setup()


    vim.keymap.set(
      'n',
      '[d',
      function ()
        trouble.open()
        trouble.previous({skip_groups = true, jump = true})
      end,
      { desc = 'Go to previous diagnostic message' }
    )

    vim.keymap.set(
      'n',
      ']d',
      function ()
        trouble.open()
        trouble.next({skip_groups = true, jump = true})
      end,
      { desc = 'Go to next diagnostic message' }
    )

    vim.keymap.set(
      'n',
      '<leader>dq',
      trouble.toggle,
      { desc = 'Open diagnostics list' }
    )
    
  end
}
