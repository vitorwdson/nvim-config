return {
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   opts = {
  --     suggestion = { enabled = false },
  --     panel = { enabled = false },
  --     filetypes = {
  --       markdown = true,
  --       help = true,
  --     },
  --   },
  -- },
  {
    "saghen/blink.cmp",
    -- dependencies = { 'rafamadriz/friendly-snippets' },
    dependencies = {
      -- "fang2hou/blink-copilot",
      {
        "supermaven-inc/supermaven-nvim",
        opts = {
          disable_inline_completion = true, -- disables inline completion for use with cmp
          disable_keymaps = true, -- disables built in keymaps for more manual control
        },
      },
      {
        "huijiro/blink-cmp-supermaven",
      },
    },
    version = "1.*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "default",
        ["<Tab>"] = false,
        ["<S-Tab>"] = false,
        ["<c-l>"] = { "snippet_forward", "fallback" },
        ["<c-j>"] = { "snippet_backward", "fallback" },
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      signature = {
        enabled = true,
      },

      completion = {
        documentation = { auto_show = true },
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
      },

      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
          -- "copilot",
          "supermaven",
        },
        providers = {
          -- copilot = {
          --   name = "copilot",
          --   module = "blink-copilot",
          --   score_offset = 100,
          --   async = true,
          --   opts = {},
          -- },
          supermaven = {
            name = "supermaven",
            module = "blink-cmp-supermaven",
            async = true,
          },
        },
      },

      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
