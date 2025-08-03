return {
  "mfussenegger/nvim-lint",
  config = function()
    require('lint').linters_by_ft = {
      htmldjango = {'djlint'},
    }

    local djlint = require("lint").linters.djlint
    djlint.args = {
      "--configuration",
      vim.fn.stdpath("config") .. "/.djlintrc",
      '--linter-output-format',
      '{line}:{code}: {message}',
      '-',
    }

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
