# Chromium_contributing_tips (macOS)
Chromium C++ Codebase contributing tricks &amp; tips for myself

This is docs for macOS, for other OS, please refer to [Ubuntu 22.04](README.md) or [Windows.md](Windows.md)

# Get the code
## Prerequisits
1. Git

## Get the `depot_tools` [ref](https://chromium.googlesource.com/chromium/src/+/main/docs/mac_build_instructions.md#install)
```console
mkdir -p ~/Sources/Chromium/depot_tools
cd ~/Sources/Chromium/depot_tools
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git .
# export PATH=/path/to/depot_tools:$PATH  OR add depot_tools path to PATH on Windows machine
```


# Faster git operations
## MacOS [ref](https://chromium.googlesource.com/chromium/src/+/HEAD/docs/mac_build_instructions.md#improving-performance-of-git-commands)
```console
sysctl -a | egrep 'kern\..*vnodes'
sudo sysctl kern.maxvnodes=$((512*1024))

sudo tee /Library/LaunchDaemons/kern.maxvnodes.plist > /dev/null <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
      <string>kern.maxvnodes</string>
    <key>ProgramArguments</key>
      <array>
        <string>sysctl</string>
        <string>kern.maxvnodes=524288</string>
      </array>
    <key>RunAtLoad</key>
      <true/>
  </dict>
</plist>
EOF

git update-index --test-untracked-cache
git config core.untrackedCache true
git config core.fsmonitor true
```