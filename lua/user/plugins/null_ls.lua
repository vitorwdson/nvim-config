return {
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        automatic_installation = true,
        ensure_installed = {
          "black",
          "isort",
          "prettier",
          "templ",
          "htmx-lsp",
          "sql-formatter",
        }
      })

      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.prettier.with({
            filetypes = { "css" },
          }),
          null_ls.builtins.formatting.sql_formatter.with({
            generator_opts = {
              command = "sql-formatter",
              args = { "-c", vim.fn.stdpath("config") .. "/sql-formatter.json" },
              to_stdin = true,
            },
          }),
        },
      })
    end
  },
}
