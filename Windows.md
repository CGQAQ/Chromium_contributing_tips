# Chromium_contributing_tips (Windows)
Chromium C++ Codebase contributing tricks &amp; tips for myself

This is docs for Windows, for other OS, please refer to [Ubuntu 22.04](README.md) or [macOS](macOS.md)


# Get the code
## Prerequisits
1. Git

## Get the `depot_tools` [Windows](https://chromium.googlesource.com/chromium/src/+/main/docs/windows_build_instructions.md#install) 
```console
mkdir -p ~/Sources/Chromium/depot_tools
cd ~/Sources/Chromium/depot_tools
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git .
# export PATH=/path/to/depot_tools:$PATH  OR add depot_tools path to PATH on Windows machine
```

## Get the code [Windows](https://chromium.googlesource.com/chromium/src/+/main/docs/windows_build_instructions.md#get-the-code) [macOS](https://chromium.googlesource.com/chromium/src/+/main/docs/mac_build_instructions.md#get-the-code)
```console
mkdir -p ~/Sources/Chromium/Source
cd ~/Sources/Chromium/Source
fetch chromium
cd src
git checkout main
git pull
gclient sync
```

# Faster build [ref](https://chromium.googlesource.com/chromium/src/+/HEAD/docs/windows_build_instructions.md#faster-builds)
1. gn args out/release
Then input:
```gn
is_component_build = true
is_debug = false
symbol_level = 0
```
save and exit editor

2. `autoninja -C out/release`
3. `./out/release/chrome.exe`

# Faster git operations
