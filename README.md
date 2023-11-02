# Chromium_debugging_tips
Chromium C++ Codebase debugging tricks &amp; tips for myself


# Get the code
## Prerequisits
1. Git

## Get the `depot_tools`
```console
mkdir -p ~/Sources/Chromium/depot_tools
cd ~/Sources/Chromium/depot_tools
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git .
# export PATH=/path/to/depot_tools:$PATH  OR add depot_tools path to PATH on Windows machine
```

## Get the code
```console
mkdir -p ~/Sources/Chromium/Source
cd ~/Sources/Chromium/Source
fetch chromium
cd src
git checkout main
git pull
gclient sync
```

# Faster build
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


# Debug by logging
1. `./out/release/chrome.exe  --enable-logging=stderr --v=-1`
2. in code
```cpp
#include "base/logging.h"
// ...
LOG(ERROR) << "YOUR LOG" << YOUR_VARIABLE ;
```

# And of course [StackTrace](https://chromium.googlesource.com/chromiumos/docs/+/master/stack_traces.md#how-to-use-base_stacktrace)
```cpp
#include "base/debug/stack_trace.h"
// ...
LOG(ERROR) << "StackTrace: " << base::debug::StackTrace{};


