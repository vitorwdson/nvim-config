return {
  "m4xshen/hardtime.nvim",
  dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  priority = 1000,
  opts = {
    restricted_keys = {
      ["<CR>"] = {},
      ["<C-M>"] = {},
      ["<C-N>"] = {},
      ["<C-P>"] = {},
    },
    disabled_filetypes = {
      "TelescopePrompt",
      "checkhealth",
      "help",
      "lazy",
      "mason",
      "netrw",
      "noice",
      "notify",
      "undotree",
      "fugitive",
      "harpoon",
    }
  }
}
