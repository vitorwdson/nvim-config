return {
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
}
