# Dotfiles

... just my Personal Dotfiles.

## Windows

These dotfiles were created for use on a macOS system (intel and apple silicon). However, they should run on Windows without any problems.

## Linux

These dotfiles were created for use on a macOS system (intel and apple silicon). However, they will run on Linux (Debian) without any problems.

Check this awesome and fucking minimalistic [Debian-Setup](https://github.com/RaphaeleL/DebianSetup) out for more.

## MacOS

### Spaces in Dock

Use this Command for one Space Item in the Dock. Reuse it, how often you want.

```bash 
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
killall Dock
```

### TouchID for `sudo` access in Terminal

1. open a Terminal
2. switch to the root user with `sudo su -`
3. edit the `/etc/pam.d/sudo` file with a command-line editor such as `vim`
4. the contents of this file should look like this

```
# sudo: auth account password session
auth       sufficient     pam_smartcard.so
auth       required       pam_opendirectory.so
account    required       pam_permit.so
password   required       pam_deny.so
session    required       pam_permit.so
```

`pam_smartcard.so` may not be present on older macos versions.

5. add the following line on the top

```
auth       sufficient     pam_tid.so
```

it should look like this

```
# sudo: auth account password session
auth       sufficient     pam_smartcard.so
auth       required       pam_opendirectory.so
account    required       pam_permit.so
password   required       pam_deny.so
session    required       pam_permit.so
```

6. save the file
7. start a new terminal session
8. try it out
