# Chromium Contributing Tips — macOS

Personal tricks and tips for contributing to the Chromium C++ codebase on macOS.

> For other platforms, see [Ubuntu 22.04](README.md) or [Windows](Windows.md).

---

## Table of Contents

- [Getting the Code](#getting-the-code)
- [Faster Git Operations](#faster-git-operations)

---

## Getting the Code

### Prerequisites

1. Git

### Installing `depot_tools` ([ref](https://chromium.googlesource.com/chromium/src/+/main/docs/mac_build_instructions.md#install))

```console
mkdir -p ~/Sources/Chromium/depot_tools
cd ~/Sources/Chromium/depot_tools
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git .
export PATH="/path/to/depot_tools:$PATH"
```

---

## Faster Git Operations ([ref](https://chromium.googlesource.com/chromium/src/+/HEAD/docs/mac_build_instructions.md#improving-performance-of-git-commands))

### Increase `maxvnodes`

Check and set the vnode limit:

```console
sysctl -a | egrep 'kern\..*vnodes'
sudo sysctl kern.maxvnodes=$((512*1024))
```

To persist the setting across reboots, create a launch daemon:

```console
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
```

### Enable Git Caching

```console
git update-index --test-untracked-cache
git config core.untrackedCache true
git config core.fsmonitor true
```