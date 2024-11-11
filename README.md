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
    chmod +x setupmac.sh
    ./setupmac.sh

    brew cleanup
    ```

- Reboot

- Manual todo

    - Import private key from your password manager
    
    ```
    # Regenerate pubkey
    ssh-keygen -f ~/.ssh/id_ed25519 -y > ~/.ssh/id_ed25519.pub
    ```
    - Set correct login items
    - Login to obsidian
    - Install printer
    - Disable private mac on wifi where needed
