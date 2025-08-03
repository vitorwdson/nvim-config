return {
  "stevearc/oil.nvim",
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  lazy = false,
  config = function()
    ---@module 'oil'
    ---@type oil.SetupOpts
    require("oil").setup({
      default_file_explorer = true,
      watch_for_changes = true,
      use_default_keymaps = false,
      view_options = {
        show_hidden = true,
        case_insensitive = false,
        natural_order = "fast",
      },
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
      },
    })
    vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>")
    vim.keymap.set("n", "-", "<cmd>Oil<cr>")
  end,
}
