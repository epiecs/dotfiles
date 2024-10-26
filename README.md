# Dotfiles

A collection of my dotfiles

## Mac setup

- Install homebew

    `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

- Install git

    `brew install git`

- Clone this repository and navigate to the directory

    ```
    cd ~
    git clone git@github.com:epiecs/dotfiles.git
    cd ~/dotfiles
    ```

- Install all packages with the `Brewfile`

    `brew bundle install --file=~/dotfiles/Brewfile`

- Some packages can not be installed via homebrew. Install these with mas

    ```
    # Amphetamine
    mas install 937984704

    # Wireguard
    mas install 1451685025
    ```

- Use `stow` to setup all needed dotfiles

    ```
    cd ~/dotfiles
    stow bash git karabiner linearmouse nano tmux wezterm
    ```
