#!/bin/bash

export CONF_DIR="$HOME"/.config

config() {
  cd "$CONF_DIR" && SESSION=config edit "$@" && cd -
}

vibashrc() {
  if [[ -n "$1" ]]; then
    config bash/bashrc/"${1%.sh}.sh"
  else
    config bash/bashrc/
  fi

  shell
}

vb() { vibashrc "$@"; }
__complete_vb() { __complete_files $HOME/.config/bash/bashrc .sh; }
is-interactive && complete -F __complete_vb vb vibashrc

if is-linux; then export SHELL=/usr/bin/bash
elif is-mac; then export SHELL=/usr/local/bin/bash
fi

shell() { exec "$SHELL" "$@"; }

bootstrap() {
  if is-linux; then bootstrap-linux "$@"
  elif is-mac; then bootstrap-mac "$@"
  else error "oh no" && return 1
  fi
}

bootstrap-global() {
  mkdir -p ~/.local/bin

  execd $ln .config/git/gitconfig ~/.gitconfig

  execd $ln .config/nvim ~/.vim
  execd $ln .config/nvim/nvim.sh ~/.vimrc

  execd $ln .config/bash/init.sh ~/.bashrc
  execd echo '[[ -t 0 ]] && . "$HOME"/.bashrc' > ~/.bash_profile

  execd mkdir -p ~/.cache/vim/undo/
  execd mkdir -p ~/.cache/vim/swap/
  execd mkdir -p ~/.cache/vim/backup/

}

bootstrap-linux() {
  local ln="ln -snf"
  execd dconf dump /org/gnome/terminal/ | fgrep -q 'Thankful Eyes' || {
    execd bash ~/.config/gnome-terminal/thankful-eyes.sh
  }
  bootstrap-global
  execd $ln ~/.config/xmonad/xmonad.hs ~/.xmonad/xmonad.hs
  execd $ln ~/.config/uim ~/.uim.d
  execd $ln ~/.config/x/xinitrc ~/.xinitrc
  execd mkdir -p ~/Screenshots
}

bootstrap-mac() {
  local ln="/bin/ln -shf"
  bootstrap-global

  $ln ~/.config/bin/spaces ~/.local/bin/spaces

  # some defaults commands only work globally ("sudo"), some only work as the user
  # I'm too lazy to figure out which one needs what
  # so just set all globally and for the user simultaneously
  for prefix in execd 'execd sudo'; do
    # bluetooth audio settings
    $prefix defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Max (editable)" 80
    $prefix defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" 80
    $prefix defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool (editable)" 80
    $prefix defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool Min (editable)" 80
    $prefix defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool" 80
    $prefix defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Max" 80
    $prefix defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Min" 80

    $prefix defaults write bluetoothaudiod "Enable AAC codec" -bool true
    $prefix defaults write bluetoothaudiod "Enable AptX codec" -bool true

    # animation speedups
    $prefix defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
    $prefix defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
    $prefix defaults write com.apple.dock expose-animation-duration -float 0.05
    $prefix defaults write com.apple.dock minimize-to-application -bool true
    $prefix defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
    $prefix defaults write com.apple.dock show-recents -bool false

    # save panel settings
    $prefix defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    $prefix defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

    # Disable quarantine dialog and crash reporter
    $prefix defaults write com.apple.LaunchServices LSQuarantine -bool false
    $prefix defaults write com.apple.CrashReporter DialogType -string "none"

    # set highlight colour to light violet
    $prefix defaults write NSGlobalDomain AppleHighlightColor -string "0.78823529 0.65098039 1.0"

    # enable "quit finder"
    $prefix defaults write com.apple.finder QuitMenuItem -bool true

    # screensaver settings
    $prefix defaults write com.apple.screensaver askForPassword -int 1
    $prefix defaults write com.apple.screensaver askForPasswordDelay -int 0

    $prefix defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
    $prefix defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true

    # search current folder by default
    $prefix defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # safari settings
    $prefix defaults write com.apple.Safari UniversalSearchEnabled -bool false
    $prefix defaults write com.apple.Safari SuppressSearchSuggestions -bool true
    $prefix defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
    $prefix defaults write com.apple.Safari HomePage -string "about:blank"
    $prefix defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
    $prefix defaults write com.apple.Safari ShowFavoritesBar -bool false
    $prefix defaults write com.apple.Safari ShowSidebarInTopSites -bool false
    $prefix defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
    $prefix defaults write com.apple.Safari IncludeDevelopMenu -bool true
    $prefix defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
    $prefix defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
    $prefix defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
    $prefix defaults write com.apple.Safari AutoFillFromAddressBook -bool false
    $prefix defaults write com.apple.Safari AutoFillPasswords -bool false
    $prefix defaults write com.apple.Safari AutoFillCreditCardData -bool false
    $prefix defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false
    $prefix defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true
    $prefix defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
    $prefix defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

    # mail settings
    $prefix defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
    $prefix defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "no"
    $prefix defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"
    $prefix defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

    # stop .DS_Store
    $prefix defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    $prefix defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    # arrange by grid on desktop
    $prefix /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
    $prefix /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
    $prefix /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

    # Open and save files as UTF-8 in TextEdit
    $prefix defaults write com.apple.TextEdit RichText -int 0
    $prefix defaults write com.apple.TextEdit PlainTextEncoding -int 4
    $prefix defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

    # disable auto-substitutions
    $prefix defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
    $prefix defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
    $prefix defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
    $prefix defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

    # don't show dialog for thumb drives
    $prefix defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

    # disable dictation
    $prefix defaults write com.apple.hitoolbox AppleDictationAutoEnable -bool false

    # Enable the automatic update check
    $prefix defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
    $prefix defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
    $prefix defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
    $prefix defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
    $prefix defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1
    $prefix defaults write com.apple.commerce AutoUpdate -bool true

    sudo chflags nohidden /Volumes
    sudo nvram StartupMute=%00
    sudo spctl --master-disable
  done
}
