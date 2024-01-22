local lualine_filetype = {
  'filename',
  file_status = true,         -- Displays file status (readonly status, modified status)
  newfile_status = true,     -- Display new file status (new file means no write after created)
  path = 1,                   -- 0: Just the filename
  -- 1: Relative path
  -- 2: Absolute path
  -- 3: Absolute path, with tilde as the home directory
  -- 4: Filename and parent dir, with tilde as the home directory

  shorting_target = 40,     -- Shortens path to leave 40 spaces in the window
  -- for other components. (terrible name, any suggestions?)
  symbols = {
    modified = '',          -- Text to show when the file is modified.
    readonly = '',          -- Text to show when the file is non-modifiable or readonly.
    unnamed = '[No Name]',     -- Text to show for unnamed buffers.
    newfile = '',         -- Text to show for newly created file before first write
  }
}

return {
  {
    -- Theme inspired by Atom
    'Mofiqul/dracula.nvim',
    priority = 1000,
    config = function()
      require('dracula').setup({
        colors = {},
        show_end_of_buffer = true,    -- default false
        transparent_bg = true,        -- default false
        lualine_bg_color = "#44475a", -- default nil
        italic_comment = true,        -- default false
        overrides = {
        },
      })
      vim.cmd.colorscheme 'dracula'
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'dracula',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        global_status = true,
      },
      winbar = {
        lualine_y = {
          'diagnostics',
        },
        lualine_z = {
          lualine_filetype,
        },
      },
      inactive_winbar = {
        lualine_z = {
          lualine_filetype,
        },
      },
      sections = {
        lualine_c = {},
      },
    },
  },

  {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require 'nvim-web-devicons'.setup {
        -- your personnal icons can go here (to override)
        -- you can specify color or cterm_color instead of specifying both of them
        -- DevIcon will be appended to `name`
        override = {
          zsh = {
            icon = "",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh"
          }
        },
        -- globally enable different highlight colors per icon (default to true)
        -- if set to false all icons will have the default icon's color
        color_icons = true,
        -- globally enable default icons (default to false)
        -- will get overriden by `get_icons` option
        default = true,
        -- globally enable "strict" selection of icons - icon will be looked up in
        -- different tables, first by filename, and if not found by extension; this
        -- prevents cases when file doesn't have any extension but still gets some icon
        -- because its name happened to match some extension (default to false)
        strict = true,
        -- same as `override` but specifically for overrides by filename
        -- takes effect when `strict` is true
        override_by_filename = {
          [".gitignore"] = {
            icon = "",
            color = "#f1502f",
            name = "Gitignore"
          }
        },
        -- same as `override` but specifically for overrides by extension
        -- takes effect when `strict` is true
        override_by_extension = {
          ["log"] = {
            icon = "",
            color = "#81e043",
            name = "Log"
          }
        },
      }
    end,
  },

  {
    'prichrd/netrw.nvim',
    config = function()
      require 'netrw'.setup {
        use_devicons = true, -- Uses nvim-web-devicons if true, otherwise use the file icon specified above
      }
      vim.g.netrw_browse_split = 0
      vim.g.netrw_banner = 0
      vim.g.netrw_winsize = 25
    end,
  },

  {
    'brenoprata10/nvim-highlight-colors',
    config = function()
      require('nvim-highlight-colors').setup {}
    end
  },
}
