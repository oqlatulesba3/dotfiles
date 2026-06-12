-- Filetype detection for Arabic files
vim.filetype.add({
  extension = {
    ar = 'arabic',
    arabic = 'arabic',
  },
  pattern = {
    ['.*%.ar'] = 'arabic',
    ['.*%.arabic'] = 'arabic',
  },
})