# Environment setup 

## Security

Enable Filevault + Firewall

## Terminal setup
- Terminal: iTerm2 (brew)
- Shell: ZSH
- Plugins: [Zinit](https://github.com/zdharma/zinit)
- Shell: Powerlevel10k (https://github.com/romkatv/powerlevel10k)

See [`.zshrc`](.zshrc).

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
pyenv install 3.8.5

# Create virtualenv  
cd deal-radar
pyenv virtualenv 3.8.5 [env_name]-3.7.0

# Add to .python-version
pyenv local [env_name]-3.7.0
```
