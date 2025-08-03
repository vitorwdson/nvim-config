return {
    cmd = { 'biome', 'lsp-proxy', '--config-path=' .. vim.fn.stdpath("config") },
    root_dir = require('lspconfig').util.root_pattern('biome.json', 'biome.jsonc', 'package.json'),
}
