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

      'nanotee/sqls.nvim',
    },
    config = function()
      local on_attach = function(client, bufnr)
        if client.name == 'ruff_lsp' then
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end

        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        nmap('<leader>gt', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- See `:help K` for why this keymap
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('L', vim.lsp.buf.signature_help, 'Signature Documentation')
        vim.keymap.set('i', "C-k", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Documentation" })

        -- Lesser used LSP functionality
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
      end

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              workspace = {
                checkThirdParty = false,
                library = {
                  '${3rd}/luv/library',
                  unpack(vim.api.nvim_get_runtime_file('', true)),
                },
              },
            },
          },
        },
        emmet_ls = {
          filetypes = { "html", "javascriptreact", "svelte", "pug",
            "typescriptreact", "vue", "htmldjango", "templ" },
          init_options = {
            html = {
              options = {
                ["bem.enabled"] = true,
              },
            },
          }
        },
        gopls = {
          gofumpt = true,
        },
        html = { filetypes = { 'html', 'twig', 'hbs', 'templ' } },
        jsonls = {},
        pyright = {
          pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = 'openFilesOnly',
              ignore = { '*' },
            },
          },
        },
        ruff_lsp = {
          init_options = {
            settings = {
              args = {},
            }
          }
        },
        tsserver = {},
        taplo = {},
        -- biome = {
        --   cmd = { 'biome', 'lsp-proxy', '--config-path=' .. vim.fn.stdpath("config") },
        --   root_dir = require('lspconfig').util.root_pattern('biome.json', 'biome.jsonc', 'package.json'),
        -- },
        tailwindcss = {
          filetypes = { "html", "javascriptreact", "svelte", "typescriptreact", "vue", "htmldjango", "templ" },
          init_options = { userLanguages = { templ = "html" } },
        },
        cssls = {},
        sqls = {
          filetypes = { "sql" },
        },
        marksman = {
          filetypes = { "md" },
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
      capabilities = vim.tbl_deep_extend(
        'force',
        capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )

      local mason_lspconfig = require 'mason-lspconfig'

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }
      mason_lspconfig.setup_handlers {
        function(server_name)
          local server = servers[server_name]
          local settings = {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = server,
          }

          if server then
            if server.filetypes then
              settings.filetypes = server.filetypes
            end
            if server.init_options then
              settings.init_options = server.init_options
            end
            if server.cmd then
              settings.cmd = server.cmd
            end
          end

          require('lspconfig')[server_name].setup(settings)
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

      vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

      vim.keymap.set("n", "<leader>f", function()
        local opts = {
          timeout_ms = 5000,
          filter = function(client)
            return client.name ~= 'sqls'
          end,
        }

        if vim.bo.filetype == "templ" then
          opts.filter = function(client)
            return client.name == 'templ'
          end
        end

        vim.lsp.buf.format(opts)

        if vim.fn.exists(":FormatGoSQL") > 0 then
          vim.cmd("FormatGoSQL")
        end
      end)
    end
  },
}
