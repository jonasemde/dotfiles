# Jonas dotfiles

My personal dotfiles. Also used by some other geeks at [mindtwo.de](https://www.mindtwo.de)

You can install them by cloning the repository as '.dotfiles' in your OSX homedirectory and running the bootstrap-script.

The bootstrap script can be run be cd-ing into the .dotfiles directory and performing this command:
```bash
./bootstrap
```

## Daily Updates Automation

Automates system package updates for Homebrew, npm, and Composer. Runs twice daily (10 AM & 6 PM).

### Setup

```bash
cd ~/.dotfiles
cp com.user.daily-updates.plist.template com.user.daily-updates.plist
cp bin/daily-updates.sh.template bin/daily-updates.sh
sed -i '' "s|/ABSOLUTE/PATH/TO/HOME|$HOME|g" com.user.daily-updates.plist bin/daily-updates.sh
cp com.user.daily-updates.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.user.daily-updates.plist
```

### Management

```bash
# Enable/Disable
launchctl load ~/Library/LaunchAgents/com.user.daily-updates.plist
launchctl unload ~/Library/LaunchAgents/com.user.daily-updates.plist

# Status & Manual Run
launchctl list | grep daily-updates
launchctl start com.user.daily-updates

# Logs
tail -f /tmp/daily-updates.log
```

**Note:** Working files contain user-specific paths and are git-ignored. Always edit `.template` versions.

## Thanks to for inspiration…
[freekmurze](https://github.com/freekmurze/dotfiles)
