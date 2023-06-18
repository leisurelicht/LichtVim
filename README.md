<h1 align="center">
  LichtVim
</h1>

<div align="center"><p>
    <a href="https://github.com/leisurelicht/LichtVim/pulse">
      <img alt="Last commit" src="https://img.shields.io/github/last-commit/leisurelicht/LichtVim?style=flat-square&logo=starship&color=8bd5ca&logoColor=D9E0EE&labelColor=302D41"/>
    </a>
    <a href="https://github.com/leisurelicht/LichtVim/blob/main/LICENSE">
      <img alt="License" src="https://img.shields.io/github/license/leisurelicht/LichtVim?style=flat-square&logo=starship&color=ee999f&logoColor=D9E0EE&labelColor=302D41" />
    </a>
    <a href="https://github.com/leisurelicht/LichtVim/issues">
      <img alt="Issues" src="https://img.shields.io/github/issues/leisurelicht/LichtVim?style=flat-square&logo=bilibili&color=F5E0DC&logoColor=D9E0EE&labelColor=302D41" />
    </a>
    <a href="https://github.com/leisurelicht/LichtVim">
      <img alt="Repo Size" src="https://img.shields.io/github/repo-size/leisurelicht/LichtVim?color=%23DDB6F2&label=SIZE&logo=codesandbox&style=flat-square&logoColor=D9E0EE&labelColor=302D41" />
    </a>
</div>

<h4 align="center">
  一个仿造 <a href="https://github.com/LazyVim/LazyVim">LazyVim</a> 的个人用 Neovim 配置</br>
  
  A Custom Neovim Config Like <a href="https://github.com/LazyVim/LazyVim">LazyVim</a>
</h4>

## ⚡️ Requirements

- [Neovim](https://github.com/neovim/neovim) >= **0.9.0** (needs to be built with **LuaJIT**)
- [Nerd Font](https://www.nerdfonts.com/)
- [fzf](https://github.com/junegunn/fzf) (for fuzzy search)
- [fd](https://github.com/sharkdp/fd) (for fuzzy search)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (for fuzzy search)
- [git](https://git-scm.com) >= **2.19.0** (for partial clones support)
- [sqlite](https://github.com/sqlite/sqlite)
- [lazygit](https://github.com/jesseduffield/lazygit) 
- [npm](https://github.com/npm/cli) (for install lsp) 
- [im-select](https://github.com/daipeihust/im-select) (if you use macOS or windows)
- [lua](https://www.lua.org/) (for install lsp **option**) 
- [luarocks](https://github.com/luarocks/luarocks) (for install lsp **option**) 
- [go](https://go.dev) (for install lsp  **option**)

## 🚀 Getting Started

可以直接使用 LazyVim 的 [starter](https://github.com/LazyVim/starter) 或者参考我的 Neovim 启动配置文件[在这](https://github.com/leisurelicht/.licht-config/tree/master/vi/nvim)。这两是一样的。</br>
you can just use LazyVim's [starter](https://github.com/LazyVim/starter) or you can refer to my Neovim start config file [here](https://github.com/leisurelicht/.licht-config/tree/master/vi/nvim). they are the same. 

或者你也可以先用 docker 试试。</br>
or you can use docker to try first.

```
docker run -w /root -it --rm alpine:edge /bin/sh -c 'apk update && apk add --no-cache curl wget git ripgrep fd fzf nodejs npm neovim neovim-doc sqlite sqlite-dev lazygit go build-base --update && mkdir -p ~/.config/nvim/ && curl -o ~/.config/nvim/init.lua https://raw.githubusercontent.com/leisurelicht/.licht-config/master/vi/nvim/lua/config/try.lua ; bash'
```

如果你无法访问`raw.githubusercontent.com`,你可以使用[GitHub520](https://github.com/521xueweihan/GitHub520)项目里`raw.githubusercontent.com`的`host ip`替换下面命令中的`host ip`,然后再重试，就能正常访问了。

```
docker run -w /root -it --rm alpine:edge /bin/sh -c 'echo "185.199.108.133 raw.githubusercontent.com" >> /etc/hosts && apk update && apk add --no-cache curl wget git ripgrep fd fzf nodejs npm neovim neovim-doc sqlite sqlite-dev lazygit go build-base --update && mkdir -p ~/.config/nvim/ && curl -o ~/.config/nvim/init.lua https://raw.githubusercontent.com/leisurelicht/.licht-config/master/vi/nvim/lua/config/try.lua ; bash'
```

## Thanks Too

+ [LazyVim](https://github.com/LazyVim/LazyVim)
+ [Nvchad](https://github.com/NvChad/NvChad)
+ [AstroNvim](https://github.com/AstroNvim/AstroNvim)
