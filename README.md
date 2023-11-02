# Chromium_debugging_tips
Chromium C++ Codebase debugging tricks &amp; tips for myself


# faster build
1. gn args out/release
Then input:
```gn
is_component_build = true
is_debug = false
symbol_level = 0
```
save and exit editor

2. `autoninja -C out/release`
3. `./out/release/Chromium.exe`
