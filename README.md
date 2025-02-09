# Chromium_contributing_tips (Ubuntu 22.04)
Chromium C++ Codebase contributing tricks &amp; tips for myself. I'm using ubuntu 22.04 right now, so other OS docs are likely not up-to-date.

This is docs for ubuntu 22.04, for other OS, please refer to [macOS.md](macOS.md) or [Windows.md](Windows.md)

# Get the code
### Prerequisits
1. Git
2. Python v3.8+

### Install depot_tools [ref](https://chromium.googlesource.com/chromium/src/+/main/docs/linux/build_instructions.md#Install)
```console
mkdir -p ~/code/google/
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git ~/code/google/depot_tools
export PATH="${HOME}/code/google/depot_tools:$PATH"
```
### Get the code [ref](https://chromium.googlesource.com/chromium/src/+/main/docs/linux/build_instructions.md#Get-the-code)
```console
mkdir -p ~/code/google/chromium && cd ~/code/google/chromium
fetch --nohooks chromium
cd src
./build/install-build-deps.sh
gclient runhooks
```
### Setting up builds
```console
gn gen out/Default
```

### Update your checkout [ref](https://chromium.googlesource.com/chromium/src/+/main/docs/linux/build_instructions.md#Update-your-checkout)
```console
~ git rebase-update
~ gclient sync -Df
```

# Build
### Faster build [ref](https://chromium.googlesource.com/chromium/src/+/main/docs/linux/build_instructions.md#Faster-builds)
```console
gn args out/Default
enable_nacl=false
symbol_level=1
blink_symbol_level=1
v8_symbol_level=0
```
### Start build [ref](https://chromium.googlesource.com/chromium/src/+/main/docs/linux/build_instructions.md#Build-Chromium)
```console
autoninja -C out/Default chrome
```

### List targets
```console
gn ls out/Default
```

### Run
```console
out/Default/chrome
```

# Generate `compile_commands.json` [ref](https://chromium.googlesource.com/chromium/src/+/master/docs/clangd.md#setting-up)
```console
# unix like
tools/clang/scripts/generate_compdb.py -p out/Default > compile_commands.json

# powershell
# NOTE: if failed, please check python version, need python3
python tools/clang/scripts/generate_compdb.py -p out/Default | out-file -encoding utf8 compile_commands.json
```

# Debug
### Logging [ref](https://www.chromium.org/for-testers/enable-logging/)
1. `./out/release/chrome.exe  --enable-logging=stderr --v=-1`
2. in code
```cpp
#include "base/logging.h"
// ...
LOG(ERROR) << "YOUR LOG" << YOUR_VARIABLE ;
```

### StackTrace [ref](https://chromium.googlesource.com/chromiumos/docs/+/master/stack_traces.md#how-to-use-base_stacktrace)
```cpp
#include "base/debug/stack_trace.h"
// ...
LOG(ERROR) << "StackTrace: " << base::debug::StackTrace{};
```
need `--disable-gpu-sandbox` flag if you are debugging gpu process, `--no-sandbox` flag if you are debugging one of the renderer processes

# Unit tests
### run unittests locally [ref](https://www.chromium.org/developers/testing/running-tests/#running-basic-tests-gtest-binaries)
1. find subset
```console
~ gn refs out/Default --testonly=true --type=executable --all chrome/browser/ui/browser_list_unittest.cc
//chrome/test:unit_tests
```
2. use it without double slash
```console
~ autoninja.bat -C ./out/Default/ 'third_party/blink/renderer/controller:blink_unittests'
ninja: Entering directory `./out/Default/'
[3/3] LINK blink_unittests.exe blink_unittests.exe.pdb
```
3. Run it with gtest_filter
for example, run `TEST(CSSMathExpressionNode, TestProgressNotationComplex)`
```console
~ out/Default/unit_tests --gtest_filter="BrowserListUnitTest.*"
```

