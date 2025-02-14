# Setup my mac

Dotfiles, mac defaults and whatnot to improve the experience of using different computers for work and lesure.

- Strive for a vanilla setup
- Do more and fiddle less
- Every computer lives its own life

## Software

> [!NOTE]
> As of writing this, Figma's latest version is not available through Homebrew Cask and Enpass is quite critical so install them manually.

- https://brew.sh
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

## Setup

Install Xcode Command Line Tools

```sh
xcode-select --install
```

Install Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Check install

```sh
brew doctor
```

Install brew apps

```sh
brew install git tig mcfly trash wget go n
```

Install brew cask apps

```sh
brew install --cask google-chrome google-drive raycast imageoptim notunes gitx bluesnooze appcleaner zed
```

Once the apps are installed, set up the MacOS preferences and finally run the audit script.

```sh
cd mac
chmod +x defaults.sh audit.command
./defaults.sh
./audit.command
```

## Development

### Node and NPM

By using n, all the hassle of installing node is gone.

```sh
n lts # or 'auto' to read the desiered version from .nvmrc/package.json
```

🚧 Running `brew doctor` will give a `Unexpected header files: /usr/local/include/node/*` warning. Haven't figured out how to fix it, nor if it's a problem. But it's there.

### Ruby on Rails

1. Follow this guide on setting up ruby and chruby on your mac: https://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/
2. Set the correct ruby version in `.zprofile`

See [Zed](zed/Readme.md) and [Visual Studio Code](vscode/Readme.md) for editor specific setups.

### Git

The [gitconfig](./git/gitconfig) file contains some useful aliases and settings. For having both personal and work projects on the same computer, i've found it useful to the `includeIf` directive to include a separate gitconfig file from the root of the work projects folder. That way you can have for example signed commits for work projects (which might require it) and unsigned commits for personal projects.

```sh
[includeIf "gitdir:~/Sites/<company>/"]
    path = ~/Sites/<company>/.gitconfig
```

### Signed commits with GitX

GitX does not support signing commits out of the box. But with the help of this workaround, i can get the signing to work:
https://josh.fail/2019/signed-commits-with-gitx/

Added a copy of the script to [git/gitx_signed_commits_workaround](./git/gitx_signed_commits_workaround).

### Chrome with web-security disabled (optional)

Add chrome with `web-security` disabled for local development, if needed.

```sh
# add to e.g. /usr/local/bin/chrome-dev
open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir="/tmp/chrome_dev_test" --disable-web-security
```
