# Chromium_contributing_tips (Ubuntu 22.04)
Chromium C++ Codebase contributing tricks &amp; tips for myself

This is docs for ubuntu 22.04, for other OS, please refer to [macOS.md](macOS.md) or [Windows.md](Windows.md)

# Get the code
## Prerequisits
1. Git

# Generate `compile_commands.json` [ref](https://chromium.googlesource.com/chromium/src/+/master/docs/clangd.md#setting-up)
```console
# unix like
tools/clang/scripts/generate_compdb.py -p out/Default > compile_commands.json

# powershell
# NOTE: if failed, please check python version, need python3
python tools/clang/scripts/generate_compdb.py -p out/Default | out-file -encoding utf8 compile_commands.json
```

# Debug by logging [ref](https://www.chromium.org/for-testers/enable-logging/)
1. `./out/release/chrome.exe  --enable-logging=stderr --v=-1`
2. in code
```cpp
#include "base/logging.h"
// ...
LOG(ERROR) << "YOUR LOG" << YOUR_VARIABLE ;
```

# And of course StackTrace [ref](https://chromium.googlesource.com/chromiumos/docs/+/master/stack_traces.md#how-to-use-base_stacktrace)
```cpp
#include "base/debug/stack_trace.h"
// ...
LOG(ERROR) << "StackTrace: " << base::debug::StackTrace{};
```
need `--disable-gpu-sandbox` flag if you are debugging gpu process, `--no-sandbox` flag if you are debugging one of the renderer processes

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


## run unittests locally [ref](https://www.chromium.org/developers/testing/running-tests/#running-basic-tests-gtest-binaries)
1. find subset
```console
PS D:\Code\Chromium\Source\src> gn refs out\Default --testonly=true --type=executable --all .\third_party\blink\renderer\core\css\css_math_expression_node_test.cc
//third_party/blink/renderer/controller:blink_unittests
//third_party/blink/renderer/controller:blink_unittests_v2
```
2. use it without double slash
```console
PS D:\Code\Chromium\Source\src> autoninja.bat -C .\out\Default\ 'third_party/blink/renderer/controller:blink_unittests'
ninja: Entering directory `.\out\Default\'
[3/3] LINK blink_unittests.exe blink_unittests.exe.pdb
```
3. Run it with gtest_filter
for example, run `TEST(CSSMathExpressionNode, TestProgressNotationComplex)`
```console
PS D:\Code\Chromium\Source\src> .\out\Default\blink_unittests.exe --gtest_filter="*TestProgress*"
IMPORTANT DEBUGGING NOTE: batches of tests are run inside their
own process. For debugging a test inside a debugger, use the
--gtest_filter=<your_test_name> flag along with
--single-process-tests.
Using sharding settings from environment. This is shard 0/1
Using 1 parallel jobs.
Note: Google Test filter = CSSMathExpressionNode.TestProgressNotation:CSSMathExpressionNode.TestProgressNotationComplex
[==========] Running 2 tests from 1 test suite.
[----------] Global test environment set-up.
[----------] 2 tests from CSSMathExpressionNode
[ RUN      ] CSSMathExpressionNode.TestProgressNotation
[       OK ] CSSMathExpressionNode.TestProgressNotation (0 ms)
[ RUN      ] CSSMathExpressionNode.TestProgressNotationComplex
[       OK ] CSSMathExpressionNode.TestProgressNotationComplex (0 ms)
[----------] 2 tests from CSSMathExpressionNode (15 ms total)

[----------] Global test environment tear-down
[==========] 2 tests from 1 test suite ran. (100 ms total)
[  PASSED  ] 2 tests.
[1/2] CSSMathExpressionNode.TestProgressNotation (0 ms)
[2/2] CSSMathExpressionNode.TestProgressNotationComplex (0 ms)
SUCCESS: all tests passed.
Tests took 2 seconds.
```

