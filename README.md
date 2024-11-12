# Dotfiles

A collection of my dotfiles

## Mac setup

- Install homebrew

    `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

- Install git

    `brew install git`

- Clone this repository and navigate to the directory

    ```
    cd ~
    git clone git@github.com:epiecs/dotfiles.git
    cd ~/dotfiles
    ```

- Install Tmux Plugin Manager if you need it. Don't forget to comment out what is needed in `.tmux.conf`

    ```
    git clone https://github.com/tmux-plugins/tpm ~/dotfiles/tmux/.tmux/plugins/tpm
    ```

- Install all packages with the `Brewfile`

    `brew bundle install --file=~/dotfiles/Brewfile`

- Some packages can not be installed via homebrew. Install these with mas

    ```
    # Amphetamine
    mas install 937984704

    # Wireguard
    mas install 1451685025

    # Microsoft remote desktop
    mas install 1295203466
    ```

- Set the correct bash version as your default shell

    ```
    sudo nano /etc/shells
    <add /opt/homebrew/bin/bash> and save

    update default shell chsh -s /opt/homebrew/bin/bash
    ```

- Use `stow` to setup all needed dotfiles

    ```
    cd ~/dotfiles
    stow bash git karabiner linearmouse nano nvim tmux wezterm
    ```

- Build the `bat` theme cache, Tokyonight is already set

    ```
    bat cache --build

    # You can also list all known themes and then install this theme in bat/.config/bat/config
    bat --list-themes 
    ```

- Mac settings

    ```
    chmod +x .macos
    ./.macos

    brew cleanup
    ```

- Reboot

- Import private key from your password manager

    ```
    mkdir -p ~/.ssh
    nano ~/.ssh/id_ed25519
    # paste key

    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/id_ed25519
    ssh-keygen -f ~/.ssh/id_ed25519 -y > ~/.ssh/id_ed25519.pub
    ```

- Set your ssh config to use your key

    ```
    nano ~/.ssh/config

    Host *
        IdentityFile /Users/gregory/.ssh/id_ed25519
    ```

- Manual todo

    - Set correct login items
    - Import rectangle config
    - Import wireguard tunnels
    - Login to obsidian
    - Install printer(s)
    - Disable private mac on wifi where needed
    - Set/check your hostname


## Handy functions

### Apps that use the built in mac preferences

App settings can be found in `~/Library/Preferences`. You can export them (example alttab):

```
defaults export com.lwouis.alt-tab-macos ~/Downloads/com.lwouis.alt-tab-macos.plist
```

An example on how to import them can be found in the `.macos` script

### App store list of apps

`mas list`

## Handy links

- https://macos-defaults.com/
- https://dev.to/darrinndeal/setting-mac-hot-corners-in-the-terminal-3de
- https://github.com/mathiasbynens/dotfiles/blob/master/.macos
- https://developer.apple.com/documentation/devicemanagement
- https://developer.okta.com/blog/2021/07/19/discover-macos-settings-with-plistwatch
- https://www.idownloadblog.com/2021/05/13/how-to-improve-bluetooth-audio-mac/