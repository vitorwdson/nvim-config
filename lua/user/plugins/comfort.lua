return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
        if vim.fn.exists(":FormatGoSQL") > 0 then
          vim.cmd("FormatGoSQL")
        end
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      lua = { "stylua" },
      go = { "goimports", "golines", "gofumpt" },
      python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
      htmldjango = { "djlint" },
      json = { "jq" },
      css = { "biome" },
      javascript = { "biome-organize-imports", "biome" },
      typescript = { "biome-organize-imports", "biome" },
      javascriptreact = { "biome-organize-imports", "biome" },
      typescriptreact = { "biome-organize-imports", "biome" },
      html = { "html_beautify" },
      templ = { "templ" },
      sql = { "sql_formatter" },
    },
    formatters = {
      stylua = {
        args = {
          "--indent-type",
          "Spaces",
          "--indent-width",
          "2",
          "--search-parent-directories",
          "--respect-ignores",
          "--stdin-filepath",
          "$FILENAME",
          "-",
        },
        range_args = function(self, ctx)
          local util = require("conform.util")
          local start_offset, end_offset = util.get_offsets_from_range(ctx.buf, ctx.range)
          return {
            "--indent-type",
            "Spaces",
            "--indent-width",
            "2",
            "--search-parent-directories",
            "--stdin-filepath",
            "$FILENAME",
            "--range-start",
            tostring(start_offset),
            "--range-end",
            tostring(end_offset),
            "-",
          }
        end,
      },
      djlint = {
        args = {
          "--configuration",
          vim.fn.stdpath("config") .. "/.djlintrc",
          "--reformat",
          "-",
        },
      },
      sql_formatter = {
        args = {
          "-c",
          vim.fn.stdpath("config") .. "/sql-formatter.json",
        },
      },
    },
  },
}
