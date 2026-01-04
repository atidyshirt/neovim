[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/colored.png)](#neovim-configuration)

# Neovim Configuration

A not so minimal neovim 0.12 configuration with lazyloading and native 0.12 feature support. It has some custom lazy
loading logic using pretty standard neovim features in `./lua/utils/lazload.lua`, thats about the only thing non
standard here, and was just added to spee up startup time.

### Structure

```bash
.
├── after/
├── ftplugin/
├── init.lua
├── lsp/
├── lua/
├──── utils/
├──── autocmds.lua
├──── configs.lua
├──── keymaps.lua
├── plugin/
└── tests/
```

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/colored.png)](#neovim-configuration)

[Changelog](./CHANGELOG.md)
