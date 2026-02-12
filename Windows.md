# Chromium Contributing Tips — Windows

Personal tricks and tips for contributing to the Chromium C++ codebase on Windows.

> For other platforms, see [Ubuntu 22.04](README.md) or [macOS](macOS.md).

---

## Table of Contents

- [Getting the Code](#getting-the-code)
- [Building](#building)
- [Faster Git Operations](#faster-git-operations)

---

## Getting the Code

### Prerequisites

1. Git

### Installing `depot_tools` ([ref](https://chromium.googlesource.com/chromium/src/+/main/docs/windows_build_instructions.md#install))

```console
mkdir -p ~/Sources/Chromium/depot_tools
cd ~/Sources/Chromium/depot_tools
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git .
```

Add the `depot_tools` directory to your system `PATH`.

### Fetching the Source ([ref](https://chromium.googlesource.com/chromium/src/+/main/docs/windows_build_instructions.md#get-the-code))

```console
mkdir -p ~/Sources/Chromium/Source
cd ~/Sources/Chromium/Source
fetch chromium
cd src
git checkout main
git pull
gclient sync
```

---

## Building

### Faster Builds ([ref](https://chromium.googlesource.com/chromium/src/+/HEAD/docs/windows_build_instructions.md#faster-builds))

1. Configure build arguments:

```console
gn args out/release
```

Set the following args:

```gn
is_component_build = true
is_debug = false
symbol_level = 0
```

2. Build:

```console
autoninja -C out/release chrome
```

3. Run:

```console
./out/release/chrome.exe
```

---

## Faster Git Operations

*(TODO: Add Windows-specific Git optimizations.)*
