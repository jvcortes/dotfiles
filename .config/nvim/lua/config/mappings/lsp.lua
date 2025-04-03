vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user_lsp_attach', {clear = true}),
  callback = function(event)
    local opts = {buffer = event.buf}

    opts.desc = "Go to definition"
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

    opts.desc = "Go to declaration"
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

    opts.desc = "Go to type definition"
    vim.keymap.set('n', 'gi', vim.lsp.buf.type_definition, opts)

    opts.desc = "Show definition signature"
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

    opts.desc = "Search symbol"
    vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)

    opts.desc = "Show line diagnostics"
    vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)

    opts.desc = "Go to next diagnostic"
    vim.keymap.set('n', '[d', vim.diagnostic.get_next, opts)

    opts.desc = "Go to previous diagnostic"
    vim.keymap.set('n', ']d', vim.diagnostic.get_prev, opts)

    opts.desc = "Show code actions"
    vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts)

    opts.desc = "Show references"
    vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, opts)

    opts.desc = "Rename"
    vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)

    opts.desc = "Show signature help"
    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
  end,
})
