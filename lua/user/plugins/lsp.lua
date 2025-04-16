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

      'mattn/vim-goaddtags',
      'nanotee/sqls.nvim',
      "nvim-lua/plenary.nvim",
      "pmizio/typescript-tools.nvim",
    },
    config = function()
      local on_attach = function(client, bufnr)
        if client.name == 'ruff' then
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
        lua_ls = { settings = { Lua = { runtime = { version = 'LuaJIT' }, workspace = { checkThirdParty = false, library = { '${3rd}/luv/library', unpack(vim.api.nvim_get_runtime_file('', true)) } } } } },
        emmet_language_server = { filetypes = { "html", "javascriptreact", "typescriptreact", "htmldjango", "templ" }, init_options = {} },
        gopls = { gofumpt = true },
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
              -- ignore = { '*' },
            },
          },
        },
        ruff = {
          init_options = {
            settings = {
              configuration = vim.fn.stdpath("config") .. "/ruff.toml",
            }
          }
        },
        -- tsserver = {},
        taplo = {},
        eslint = {},
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
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }

      local mason_lspconfig = require 'mason-lspconfig'

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      }
      mason_lspconfig.setup_handlers {
        function(server_name)
          if server_name == "tsserver" then
            return
          end

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

      require("typescript-tools").setup {
        on_attach = on_attach,
        -- handlers = { ... },
        settings = {
          -- spawn additional tsserver instance to calculate diagnostics on it
          separate_diagnostic_server = true,
          -- "change"|"insert_leave" determine when the client asks the server about diagnostic
          publish_diagnostic_on = "insert_leave",
          -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
          -- "remove_unused_imports"|"organize_imports") -- or string "all"
          -- to include all supported code actions
          -- specify commands exposed as code_actions
          expose_as_code_action = "all",
          -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
          -- not exists then standard path resolution strategy is applied
          tsserver_path = nil,
          -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
          -- (see 💅 `styled-components` support section)
          tsserver_plugins = {},
          -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
          -- memory limit in megabytes or "auto"(basically no limit)
          tsserver_max_memory = "auto",
          -- described below
          tsserver_format_options = {},
          tsserver_file_preferences = {},
          -- locale of all tsserver messages, supported locales you can find here:
          -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
          tsserver_locale = "en",
          -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
          complete_function_calls = false,
          include_completions_with_insert_text = true,
          -- CodeLens
          -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
          -- possible values: ("off"|"all"|"implementations_only"|"references_only")
          code_lens = "off",
          -- by default code lenses are displayed on all referencable values and for some of you it can
          -- be too much this option reduce count of them by removing member references from lenses
          disable_member_code_lens = true,
          -- JSXCloseTag
          -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
          -- that maybe have a conflict if enable this feature. )
          jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
          }
        },
      }

      vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end)
      vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end)
      vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float)

      local diagnostic_lines = true
      vim.diagnostic.config({
        virtual_lines = {
          severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.INFO,
          }
        },
        virtual_text = {
          severity = {
            vim.diagnostic.severity.HINT,
          }
        },
      })
      vim.keymap.set(
        'n',
        '<leader>dt',
        function()
          diagnostic_lines = not diagnostic_lines
          if diagnostic_lines then
            vim.diagnostic.config({
              virtual_lines = {
                severity = {
                  vim.diagnostic.severity.ERROR,
                  vim.diagnostic.severity.WARN,
                  vim.diagnostic.severity.INFO,
                }
              },
              virtual_text = {
                severity = {
                  vim.diagnostic.severity.HINT,
                }
              },
            })
          else
            vim.diagnostic.config({
              virtual_lines = false,
              virtual_text = true,
            })
          end
        end,
        { desc = 'Toggle diagnostic mode' }
      )

      vim.keymap.set("n", "<leader>f", function()
        local opts = {
          timeout_ms = 5000,
          filter = function(client)
            return client.name ~= 'sqls'
          end,
          async = false,
        }

        if vim.bo.filetype == "templ" then
          opts.filter = function(client)
            return client.name == 'templ'
          end
        end

        if vim.bo.filetype == "python" then
          local clients = vim.lsp.get_clients()
          ---@type vim.lsp.Client
          local ruff = nil
          for _, client in ipairs(clients) do
            if client.name == "ruff" then
              ruff = client
              break
            end
          end

          if ruff == nil then
            return
          end

          opts.filter = function(client)
            return client.name == "ruff"
          end

          local bufnr = vim.api.nvim_get_current_buf()
          local params = vim.lsp.util.make_range_params(0, ruff.offset_encoding)

          --- @diagnostic disable-next-line: inject-field
          params.context = {
            triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
            diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
          }

          local actions = ruff:request_sync("textDocument/codeAction", params, 5000, bufnr)

          if actions ~= nil and actions["result"] ~= nil then
            local fix_all = nil
            for _, action in ipairs(actions["result"]) do
              if action["kind"] == "source.fixAll.ruff" then
                fix_all = action
                break
              end
            end
            if fix_all ~= nil then
              fix_all.title = fix_all.title:gsub("\r\n", "\\r\\n")
              fix_all.title = fix_all.title:gsub("\n", "\\n")

              local result = ruff:request_sync("codeAction/resolve", fix_all, 5000, bufnr)
              if result ~= nil and result["result"] ~= nil then
                vim.lsp.util.apply_workspace_edit(result.result.edit, ruff.offset_encoding)
              end
            end
          end
        end

        vim.lsp.buf.format(opts)

        if vim.fn.exists(":FormatGoSQL") > 0 then
          vim.cmd("FormatGoSQL")
        end

        if vim.tbl_contains({ "javascript", "javascriptreact", "typescript", "typescriptreact" }, vim.bo.filetype) then
          local commands = {
            "TSToolsOrganizeImports",
          }

          for _, cmd in pairs(commands) do
            if vim.fn.exists(":" .. cmd) > 0 then
              vim.cmd(cmd)
            end
          end
        end
      end)
    end
  },
  {
    "catgoose/templ-goto-definition",
    ft = { "go" },
    config = true,
    dependenciies = "nvim-treesitter/nvim-treesitter", -- optional
  }
}
