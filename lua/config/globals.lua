local globals = {
  loaded_netrw = 1,
  loaded_netrwPlugin = 1,
  mapleader = " ",
  maplocalleader = ",",
}

for k, v in pairs(globals) do
  vim.g[k] = v
end

return globals
