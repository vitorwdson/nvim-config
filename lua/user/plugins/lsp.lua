return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "nanotee/sqls.nvim",
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      vim.lsp.enable("biome")
      vim.lsp.enable("cssls")
      vim.lsp.enable("emmet_language_server")
      vim.lsp.enable("eslint")
      vim.lsp.enable("gopls")
      vim.lsp.enable("html")
      vim.lsp.enable("htmx")
      vim.lsp.enable("jsonls")
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("basedpyright")
      vim.lsp.enable("ruff")
      vim.lsp.enable("sqls")
      vim.lsp.enable("tailwindcss")
      vim.lsp.enable("taplo")
      vim.lsp.enable("templ")
      vim.lsp.enable("ts_ls")

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client ~= nil and client.name == "ruff" then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end

          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

          map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
          map("<leader>gt", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("L", vim.lsp.buf.signature_help, "Signature Documentation")
          map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation", "i")
        end,
      })

      local diagnostic_lines = true
      local set_diagnostics = function(use_lines)
        local virtual_lines = false
        local virtual_text = {
          source = "if_many",
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
          severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.INFO,
            vim.diagnostic.severity.HINT,
          },
        }

        if use_lines then
          ---@diagnostic disable-next-line: cast-local-type
          virtual_lines = {
            severity = {
              vim.diagnostic.severity.ERROR,
              vim.diagnostic.severity.WARN,
              vim.diagnostic.severity.INFO,
            },
          }

          virtual_text.severity = {
            vim.diagnostic.severity.HINT,
          }
        end

        vim.diagnostic.config({
          severity_sort = true,
          float = { border = "rounded", source = "if_many" },
          underline = { severity = vim.diagnostic.severity.ERROR },
          signs = vim.g.have_nerd_font and {
            text = {
              [vim.diagnostic.severity.ERROR] = "󰅚 ",
              [vim.diagnostic.severity.WARN] = "󰀪 ",
              [vim.diagnostic.severity.INFO] = "󰋽 ",
              [vim.diagnostic.severity.HINT] = "󰌶 ",
            },
          } or {},
          virtual_text = virtual_text,
          virtual_lines = virtual_lines,
        })
      end

      set_diagnostics(diagnostic_lines)
      vim.keymap.set("n", "<leader>dt", function()
        diagnostic_lines = not diagnostic_lines
        set_diagnostics(diagnostic_lines)
      end)
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "lua-language-server",
        "emmet-language-server",
        "gopls",
        "html-lsp",
        "templ",
        "json-lsp",
        "basedpyright",
        "tailwindcss-language-server",
        "css-lsp",
        "sqls",
        "ruff",
        "prettier",
        "templ",
        "htmx-lsp",
        "sql-formatter",
        "gofumpt",
        "goimports",
        "golines",
        "typescript-language-server",
        "djlint",
        "stylua",
        "biome",
        "templ",
      },
    },
    enabled = function()
      -- Disable for nixos as the language servers should be installed from nixpkgs
      local out = vim.fn.system("test -d /etc/nixos && echo -n 'true'")
      return out ~= "true"
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "catgoose/templ-goto-definition",
    ft = { "go" },
    config = function() end,
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
}
