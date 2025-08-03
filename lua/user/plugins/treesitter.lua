local utils = require("user.functions.utils")

return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "nvim-treesitter/nvim-treesitter-context" },
  lazy = false,
  branch = "main",
  build = ":TSUpdate",
  config = function()
    local nvim_ts = require("nvim-treesitter")
    nvim_ts.setup()

    nvim_ts.install({
      "go",
      "gomod",
      "gowork",
      "gosum",
      "lua",
      "python",
      "tsx",
      "javascript",
      "typescript",
      "vimdoc",
      "vim",
      "css",
      "bash",
      "yaml",
      "json",
      "htmldjango",
      "html",
      "templ",
      "printf",
      "sql",
      "comment",
      "regex",
      "re2c",
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = '*',
      callback = function(event)
        local installed_parsers = nvim_ts.get_installed()
        if utils.contains(installed_parsers, event.match) then
          vim.treesitter.start()
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    require("treesitter-context").setup({
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      multiwindow = false, -- Enable multiwindow support.
      max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
      zindex = 20, -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    })
  end,
}
