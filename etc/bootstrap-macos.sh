#!/usr/bin/env zsh

# A simple script for setting up macOS dev environment.

dev="$HOME/Code"
pushd .
mkdir -p $dev
cd $dev

echo 'Enter new hostname of the machine (e.g. oaklab-2020)'
  read hostname
  echo "Setting new hostname to $hostname..."
  scutil --set HostName "$hostname"
  compname=$(sudo scutil --get HostName | tr '-' '.')
  echo "Setting computer name to $compname"
  scutil --set ComputerName "$compname"
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$compname"

pub=$HOME/.ssh/id.pub
echo 'Checking for SSH key, generating one if it does not exist...'
  [[ -f $pub ]] || ssh-keygen -t ed25519

echo 'Copying public key to clipboard. Paste it into your Github account...'
  [[ -f $pub ]] && cat $pub | pbcopy
  open 'https://github.com/account/ssh'

echo 'Creating GPG key'
  gpg --full-generate-key

echo 'Listing publig gpg key to clipboard'
  gpg --list-secret-keys --keyid-format LONG

# If we on macOS, install homebrew and tweak system a bit.
if [[ `uname` == 'Darwin' ]]; then
  which -s brew
  if [[ $? != 0 ]]; then
    echo 'Installing Homebrew...'
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  # Homebrew packages.
  brew npm nvm yarn install git coreutils openssl libyaml readline unzio curl shellcheck watchman tmux reattach-to-user-namespace ffmpeg docker diff-so-fancy 

  # Homebrew cask package
  brew cask install spectacle spotify 1password kap visual-studio-code postman docker google-chrome safari-technology-preview telegram microsoft-teams figma

  echo 'Tweaking macOS...'
    source 'etc/macos-settings.sh'
fi

echo 'Symlinking config files...'
  source 'etc/symlink-dotfiles.sh'
