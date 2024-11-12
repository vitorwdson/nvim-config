return {
  'tpope/vim-sleuth',

  {
    "lukas-reineke/indent-blankline.nvim",
    dependencies = { "hiphish/rainbow-delimiters.nvim" },
    main = "ibl",
    opts = {},
    config = function()
      -- indent-blankline configuration
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
      }

      local hooks = require "ibl.hooks"
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#ff5555" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#f1fa8c" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#8be9fd" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#ffb86c" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#50fa7b" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#bd93f9" })
      end)

      vim.g.rainbow_delimiters = {
        highlight = highlight,
        query = {
          html = "rainbow-custom",
        },
      }
      require("ibl").setup { indent = { highlight = highlight, char = "┊" } }
    end
  },

  {
    'numToStr/Comment.nvim',
    opts = {},
  },

  {
    'mbbill/undotree',
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end
  },

  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
      -- nvim-ufo configuration
      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

      require('ufo').setup({
        open_fold_hl_timeout = 150,
        close_fold_kinds_for_ft = {
          default = { 'imports', 'comment' },
        },
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end
      })
    end
  },

  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    },
    lazy = false,
  },

  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
        max_join_length = 500,
      })

      vim.keymap.set('n', '<leader>m', require('treesj').toggle)
    end,
  },

}
