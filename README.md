# Environment setup 

## Security

Enable Filevault + Firewall

## Terminal setup
- Terminal: iTerm2 (brew)
- Shell: ZSH
- Plugins: [Zinit](https://github.com/zdharma/zinit)
- Shell: Powerlevel10k (https://github.com/romkatv/powerlevel10k)

See [`.zshrc`](.zshrc).

## Symlink all dotfiles to HOME dir
```bash
ln -s $(pwd)/.*(.) ~/
```

## Brew
Install brew
```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Backup `Brewfile`
```bash
brew bundle dump
```
To restore, in the directory containing `Brewfile`:
```bash
brew bundle
```

## Extras

* Global .gitignore
```bash
git config --global core.excludesfile "$(PWD)/.global-gitignore"
```

## Python env setup
```bash
# Install pyenv and pyenv-virtualenv
brew install pyenv
brew install pyenv-virtualenv

# Add pyenv/pyenv-virtualenv init to .zshrc 
echo 'if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi' >> ~/.zshrc

# Install python 
pyenv install [version] # e.g. 3.7.10

# Create virtualenv  
cd deal-radar
pyenv virtualenv [version] [env_name]-[version] # e.g. 3.7.10 myenv-3.7.10

# Add to .python-version
pyenv local [env_name]-[version] # e.g. myenv-3.7.10
```
## R setup: install and link `gfortran`
`gfortran` now comes packaged with the gcc formula
```bash
brew install gcc
```
To link it, create `~/.R/Makevars` and add the path to the bin:
```bash
# M1 brew `/opt/homebrew/` / Intel brew `/usr/local/`
FC    = /opt/homebrew/opt/gcc/bin/gfortran
F77   = /opt/homebrew/opt/gcc/bin/gfortran
FLIBS = -L/opt/homebrew/opt/gcc/lib
``` 

