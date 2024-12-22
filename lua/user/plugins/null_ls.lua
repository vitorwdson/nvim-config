local mason_bin_folder = vim.fn.stdpath('data') .. "/mason/bin"

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
        "prettier",
        "templ",
        "htmx-lsp",
        "sql-formatter",
        "gofumpt",
        "goimports",
        "golines",
        "typescript-language-server",
        "djlint",
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

      -- if mr.refresh then
      --   mr.refresh(ensure_installed)
      -- else
      --   ensure_installed()
      -- end

      local null_ls = require("null-ls")
      local h = require("null-ls.helpers")

      null_ls.setup({
        sources = {
          -- null_ls.builtins.formatting.prettier.with({
          --   filetypes = { "css" },
          -- }),
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.sql_formatter.with({
            generator_opts = {
              command = mason_bin_folder .. "/sql-formatter",
              args = { "-c", vim.fn.stdpath("config") .. "/sql-formatter.json" },
              to_stdin = true,
            },
          }),
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.formatting.golines,
          null_ls.builtins.formatting.gofumpt,
          null_ls.builtins.formatting.djlint.with({
            generator_opts = {
              command = mason_bin_folder .. "/djlint",
              args = {
                "--configuration",
                vim.fn.stdpath("config") .. "/.djlintrc",
                "--reformat",
                "-",
              },
              to_stdin = true,
            },
          }),
          null_ls.builtins.diagnostics.djlint.with({
            generator_opts = {
              command = mason_bin_folder .. "/djlint",
              args = {
                "--configuration",
                vim.fn.stdpath("config") .. "/.djlintrc",
                "--quiet",
                "-",
              },
              to_stdin = true,
              from_stderr = false,
              ignore_stderr = true,
              format = "line",
              check_exit_code = function(code)
                return code <= 1
              end,
              on_output = h.diagnostics.from_patterns({
                {
                  pattern = [[(%w+) (%d+):(%d+) (.*).]],
                  groups = { "code", "row", "col", "message" },
                  overrides = {
                    diagnostic = { severity = INFO },
                    offsets = { col = 1 },
                  },
                },
              }),
            },
          }),
        },
      })
    end
  },
}
