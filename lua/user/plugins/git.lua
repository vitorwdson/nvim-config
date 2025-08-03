return {
  {
    "tpope/vim-fugitive",
    dependencies = {
      "tpope/vim-rhubarb",
    },
    config = function()
      vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

      local augroup = vim.api.nvim_create_augroup("fugitive-attach", { clear = true })
      vim.api.nvim_create_autocmd("BufEnter", {
        group = augroup,
        callback = function(ev)
          if vim.bo.filetype ~= "fugitive" then
            return
          end

          vim.api.nvim_buf_set_keymap(ev.buf, "n", "<leader>P", ":Git push<cr>", {})
        end,
      })
    end,
  },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        vim.keymap.set({ "n", "v" }, "]g", gs.next_hunk, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
        vim.keymap.set(
          { "n", "v" },
          "[g",
          gs.prev_hunk,
          { expr = true, buffer = bufnr, desc = "Jump to previous hunk" }
        )
      end,
    },
  },
}
