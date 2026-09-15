# Setup my laptops

Dotfiles, configs, mac defaults, and whatnot to improve the experience of using different computers for both work and lesure.

- Strive for a vanilla setup
- Do more and fiddle less
- Every computer lives its own life

## Background

Mac: 

System settings > Wallpaper > "Space gray pro"

Linux:

```
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

Install [Homebrew](https://brew.sh/) (for silicon macs)

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Check install

```sh
brew doctor
```

Install apps

```sh
brew install n git tig mcfly trash wget zsh-completions zsh-autosuggestions
```

Optional cask apps

```sh
brew install --cask google-chrome google-drive raycast imageoptim notunes gitx bluesnooze appcleaner zed
```

Install [MacPorts](https://www.macports.org/) (for older intel macs)

```
sudo port install n git tig mcfly trash wget zsh-completions zsh-autosuggestions
```

Once the apps are installed, set up the MacOS preferences and finally run the audit script.

```sh
cd mac
chmod +x defaults.sh audit.command
./defaults.sh
./audit.command
```

## WhatsApp local backups

Install [OpenMTP](https://github.com/ganeshrvel/openmtp) 

```sh
brew install openmtp --cask
```

Copy `Internal Storage > Android > media > com.whatsapp.com > Whatsapp` to your computer. If OpenMTP is not finding your Android device, check that developer options are off and the usb mode is set to "File Transfer".


## Development

### Node and NPM

Install [n](https://github.com/tj/n) for managing node versions

```sh
brew install n
```

Then install desired node version

```sh
n lts # or 'auto' to read the desiered version from project .nvmrc/package.json/etc file.
```

🚧 Running `brew doctor` will give a `Unexpected header files: /usr/local/include/node/*` warning. Haven't figured out how to fix it, nor if it's a problem. But it's there.

Finally, install global npm packages

```sh
npm install -g npm-check-updates
```

### Ruby on Rails

> [!NOTE]
> Maybe out of date, the [current guide](https://guides.rubyonrails.org/install_ruby_on_rails.html#install-ruby-on-macos) suggest using `mise`.

1. Follow this guide on setting up ruby and chruby on your mac: https://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/
2. Set the correct ruby version in `.zprofile`

### Android

Download and install [Android Studio](https://developer.android.com/studio)

Then install java runtime

```sh
brew install java

# if you need a specific JDK version, run
brew install openjdk@17

# brew will suggest post install steps, follow them.
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
