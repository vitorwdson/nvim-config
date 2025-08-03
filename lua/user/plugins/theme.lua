local lualine_filetype = {
  "filename",
  file_status = true, -- Displays file status (readonly status, modified status)
  newfile_status = true, -- Display new file status (new file means no write after created)
  path = 1, -- 0: Just the filename
  -- 1: Relative path
  -- 2: Absolute path
  -- 3: Absolute path, with tilde as the home directory
  -- 4: Filename and parent dir, with tilde as the home directory

  shorting_target = 40, -- Shortens path to leave 40 spaces in the window
  -- for other components. (terrible name, any suggestions?)
  symbols = {
    modified = "", -- Text to show when the file is modified.
    readonly = "", -- Text to show when the file is non-modifiable or readonly.
    unnamed = "[No Name]", -- Text to show for unnamed buffers.
    newfile = "", -- Text to show for newly created file before first write
  },
}

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = "latte",
          dark = "mocha",
        },
        transparent_background = true, -- disables setting the background color.
        float = {
          transparent = false, -- enable transparent floating windows
          solid = false, -- use solid styling for floating windows, see |winborder|
        },
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = false, -- dims the background color of inactive window
          shade = "dark",
          percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { "italic" }, -- Change the style of comments
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
          -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        color_overrides = {},
        custom_highlights = {},
        default_integrations = true,
        auto_integrations = false,
        integrations = {
          cmp = true,
          gitsigns = true,
          treesitter = true,
          treesitter_context = true,
          mason = true,
          telescope = true,
          harpoon = true,
          indent_blankline = {
            enabled = true,
            scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
            colored_indent_levels = false,
          },
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
            inlay_hints = {
              background = true,
            },
          },
          lsp_trouble = false,
          illuminate = {
            enabled = true,
            lsp = false,
          },
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  {
    -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    -- See `:help lualine.txt`
    config = function()
      local lualine = require("lualine")

      lualine.setup({
        options = {
          icons_enabled = true,
          theme = "catppuccin",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          global_status = true,
        },
        winbar = {
          lualine_b = {
            lualine_filetype,
          },
          lualine_c = {
            {
              "diagnostics",
              draw_empty = true,
            },
          },
        },
        inactive_winbar = {
          lualine_b = {
            lualine_filetype,
          },
          lualine_c = {
            {
              "diagnostics",
              draw_empty = true,
            },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "searchcount", "selectioncount", "location" },
        },
      })
    end,
  },

  {
    "lukas-reineke/virt-column.nvim",
    config = function()
      require("virt-column").setup({
        enable = true,
        virtcolumn = "81",
        highlight = "VirtColumn",
        exclude = {
          filetypes = {
            "lspinfo",
            "packer",
            "checkhealth",
            "help",
            "man",
            "gitcommit",
            "TelescopePrompt",
            "TelescopeResults",
            "netrw",
          },
        },
      })
      vim.api.nvim_set_hl(0, "VirtColumn", { bg = nil })
    end,
  },

  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("nvim-highlight-colors").setup({})
    end,
  },

  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

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

      local hooks = require("ibl.hooks")
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
      require("ibl").setup({ indent = { highlight = highlight, char = "┊" } })
    end,
  },
}
