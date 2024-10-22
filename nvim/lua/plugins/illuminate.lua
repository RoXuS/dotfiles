-- Description: Highlight other occurrences of the word under the cursor
return {
  'RRethy/vim-illuminate',
  config = function()
    require('illuminate').configure({
      -- providers: provider used to get references in the buffer, ordered by priority
      providers = {
        'lsp',
        'treesitter',
        'regex',
      },
      delay = 100,
    })
  end
}
