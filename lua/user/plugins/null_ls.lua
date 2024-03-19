return {
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
    },
    config = function()
      local to_install = {
        -- "black",
        -- "isort",
        "prettier",
        "templ",
        "htmx-lsp",
        "sql-formatter",
        "gofumpt",
        "goimports",
      }

      require("mason").setup()
      local mr = require("mason-registry")

      local function ensure_installed()
        for _, tool in ipairs(to_install) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end

      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end

      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          -- null_ls.builtins.formatting.black,
          -- null_ls.builtins.formatting.isort,
          -- null_ls.builtins.formatting.prettier.with({
          --   filetypes = { "css" },
          -- }),
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.sql_formatter.with({
            generator_opts = {
              command = "sql-formatter",
              args = { "-c", vim.fn.stdpath("config") .. "/sql-formatter.json" },
              to_stdin = true,
            },
          }),
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.formatting.gofumpt,
        },
      })
    end
  },
}
