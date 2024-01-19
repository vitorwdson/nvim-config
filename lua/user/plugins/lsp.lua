return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
    config = function()
      local on_attach = function(_, bufnr)
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('L', vim.lsp.buf.signature_help, 'Signature Documentation')

        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
      end

      local servers = {
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
        emmet_ls = {
          filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug",
            "typescriptreact", "vue", "htmldjango", "templ" },
          init_options = {
            html = {
              options = {
                ["bem.enabled"] = true,
              },
            },
          }
        },
        gopls = {},
        html = { filetypes = { 'html', 'twig', 'hbs', 'templ' } },
        jsonls = {},
        pyright = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = 'openFilesOnly',
            },
          },
        },
        tsserver = {},
        taplo = {},
        biome = {},
        tailwindcss = {
          filetypes = { "html", "javascriptreact", "svelte", "typescriptreact", "vue", "htmldjango", "templ" },
          init_options = { userLanguages = { templ = "html" } },
        },
      }

      require('neodev').setup()

      local configs = require "lspconfig.configs"
      if not configs.templ then
        configs.templ = {
          default_config = {
            cmd = { "templ", "lsp" },
            filetypes = { 'templ' },
            root_dir = require "lspconfig.util".root_pattern("go.mod", ".git"),
            settings = {},
          },
        }
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      local mason_lspconfig = require 'mason-lspconfig'

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      mason_lspconfig.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
            init_options = (servers[server_name] or {}).init_options,
          }
        end
      }

      require('lspconfig').htmx.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "html", "htmldjango", "templ", "typescriptreact", "javascriptreact" },
      }

      require('lspconfig').templ.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        flags = {
          debounce_text_changes = 150,
        },
      }

      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
      vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
      vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

      vim.keymap.set("n", "<leader>f", function()
        if vim.bo.filetype == "templ" then
          vim.lsp.buf.format({
            timeout_ms = 5000,
            filter = function(client)
              return client.name == 'templ'
            end,
          })
        else
          vim.lsp.buf.format({ timeout_ms = 5000 })
        end
      end)
    end
  },
}
