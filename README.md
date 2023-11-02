# Chromium_debugging_tips
Chromium C++ Codebase debugging tricks &amp; tips for myself


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
