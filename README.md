# Setup my laptops

Dotfiles, configs, mac defaults, and whatnot to improve the experience of using different computers for both work and lesure.

- Strive for a vanilla setup
- Do more and fiddle less
- Every computer lives its own life

## Background

Mac: 

System settings > Wallpaper > "Space gray pro"

Linux:

```sh
gsettings set org.gnome.desktop.background picture-options 'none'
gsettings set org.gnome.desktop.background primary-color '#7A7B81'
```

## Software

- https://brew.sh
- https://www.macports.org
- https://www.firefox.com
- https://google.com/chrome
- https://google.com/drive/download
- https://enpass.io/downloads
- https://figma.com/downloads
- https://raycast.com
- https://zed.dev
- https://freemacsoft.net/appcleaner
- https://imageoptim.com/mac
- https://github.com/gitx/gitx
- https://github.com/tombonez/noTunes
- https://github.com/odlp/bluesnooze
- https://github.com/tw93/mole

### Command Line Tools

Install Xcode Command Line Tools

```sh
xcode-select --install
```

### Package manager

Install a package manager depending on your mac architecture

#### [Homebrew](https://brew.sh/) (Silicon)

```sh
# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Check install
brew doctor

## Install apps
brew install git tig mcfly trash wget mole zsh-completions zsh-autosuggestions
```

#### [MacPorts](https://www.macports.org/) (Intel)

```sh
# Download the installer
https://www.macports.org/install.php

# Install apps
sudo port install git tig mcfly trash wget mole-cleaner zsh-completions zsh-autosuggestions
```

## Defaults & audit

Once the apps are installed, set up the MacOS preferences and finally run the audit script.

```sh
cd mac
chmod +x defaults.sh audit.command
./defaults.sh
./audit.command
```

## Development

### Node

Install [n](https://github.com/tj/n) for managing node versions

```sh
# Bootstrap if no npm available
curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s install lts

# Install n globally
npm install -g n
```

Install `ncu` for checking for updates

```sh
npm install -g npm-check-updates

# Interactive mode with a 5 day cooldown
ncu -i -c 5
```

### Ruby on Rails

See https://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac

```sh
# Homebrew
brew install chruby ruby-install

# MacPorts
sudo port install chruby ruby-install
```

Install a version of ruby, set it, and install rails

```sh
ruby-install ruby 4.0.6
chruby 4.0.6
gem install rails
```

### Laravel

See https://laravel.com/framework/docs/master/installation

```sh
/bin/bash -c "$(curl -fsSL https://php.new/install/mac/8.4)"
composer global require laravel/installer
```

### Android

Download and install [Android Studio](https://developer.android.com/studio)

Then install java runtime

```sh
# Homebrew
brew install openjdk@<version>

# MacPorts
sudo port install openjdk<version>
```

Useful Android Studio customizations:

- Behavior
  - Enable Preview Tab
  - Always Select Opened File
- VSCode Keymap plugin
- Change switcher keybinding to `ctrl+§` and tab navigation to `ctrl+tab`

Tool for mirroring/controllng android on Mac: https://github.com/Genymobile/scrcpy

### Git

The [gitconfig](./git/gitconfig) file contains some useful aliases and settings. For having both personal and work projects on the same computer, i've found it useful to the `includeIf` directive to include a separate gitconfig file from the root of the work projects folder. That way you can have for example signed commits for work projects (which might require it) and unsigned commits for personal projects.

```sh
[includeIf "gitdir:~/Sites/<company>/"]
    path = ~/Sites/<company>/.gitconfig
```

### Signed commits with GitX

GitX does not support signing commits out of the box. But with the help of this workaround, i can get the signing to work:
https://josh.fail/2019/signed-commits-with-gitx/

A copy of the script is available at [git/gitx_signed_commits_workaround](./git/gitx_signed_commits_workaround).

### Chrome with web-security disabled (optional)

Add chrome with `web-security` disabled for local development, if needed.

```sh
# add to e.g. /usr/local/bin/chrome-dev
open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir="/tmp/chrome_dev_test" --disable-web-security
```

## WhatsApp local backups

- Install [OpenMTP](https://github.com/ganeshrvel/openmtp) 
- Copy `Internal Storage > Android > media > com.whatsapp.com > Whatsapp` to your computer
- If OpenMTP is not finding your Android device, check that developer options are off and the usb mode is set to "File Transfer"
