return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    config = true,
  },
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    dependencies = { "luarocks.nvim" },
    config = function()
      require("rest-nvim").setup({
        keybinds = {
          {
            "<leader>rr", "<cmd>Rest run<cr>", "Run request under the cursor",
          },
          {
            "<leader>rl", "<cmd>Rest run last<cr>", "Re-run latest request",
          },
        }
      })
    end,
  }
}
