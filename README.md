# Chromium Contributing Tips

Personal tricks and tips for contributing to the Chromium C++ codebase.

> **Note:** This guide targets **Ubuntu 22.04** and is the most actively maintained.
> For other platforms, see [macOS](macOS.md) or [Windows](Windows.md).

---

## Table of Contents

- [Getting the Code](#getting-the-code)
- [Building](#building)
- [Stacked CLs](#stacked-cls-ref-commands)
- [Generating compile\_commands.json](#generating-compile_commandsjson-ref)
- [Debugging](#debugging)
- [Unit Tests](#unit-tests)
- [Web Tests](#web-tests)

---

## Getting the Code

### Prerequisites

1. Git
2. Python v3.8+

### Upgrading Git on Ubuntu

```console
sudo apt update && sudo apt install software-properties-common
sudo add-apt-repository ppa:git-core/ppa
sudo apt install git
```

### Installing `depot_tools` ([ref](https://chromium.googlesource.com/chromium/src/+/main/docs/linux/build_instructions.md#Install))

```console
mkdir -p ~/code/google/
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git ~/code/google/depot_tools
export PATH="${HOME}/code/google/depot_tools:$PATH"
```

### Fetching the Source ([ref](https://chromium.googlesource.com/chromium/src/+/main/docs/linux/build_instructions.md#Get-the-code))

```console
mkdir -p ~/code/google/chromium && cd ~/code/google/chromium
fetch --nohooks chromium
cd src
./build/install-build-deps.sh
gclient runhooks
```

### Setting Up clangd

Add the following to your clangd config:

```
"-j=16"
"--malloc-trim"
"--background-index"
"--pch-storage=memory"
```

### Configuring Build Arguments ([ref](https://www.chromium.org/developers/gn-build-configuration/))

```console
gn gen out/Default
gn args out/Default
```

Set the following args:

```gn
is_debug = true
symbol_level = 1
blink_symbol_level = 1
v8_symbol_level = 0
enable_nacl = false
use_rtti = true  # useful runtime type info
```

### Updating Your Checkout ([ref](https://chromium.googlesource.com/chromium/src/+/main/docs/linux/build_instructions.md#Update-your-checkout))

```console
git rebase-update
gclient sync -Df
```

---

## Building

### Faster Builds with RBE ([ref](https://chromium.googlesource.com/chromium/src/+/main/docs/linux/build_instructions.md#Faster-builds))

1. Edit your `.gclient` file to add the RBE instance ([ref](https://chromium.googlesource.com/chromium/src/+/main/docs/linux/build_instructions.md#use-reclient)):

```python
solutions = [
  {
    ...,
    "custom_vars": {
      # Add this if we needed clangd
      "checkout_clangd": True,
      # Chromium's RBE service instance. You can only use this if you have
      # been granted access. For a custom REAPI-compatible backend, change
      # this accordingly.
      "rbe_instance": "projects/rbe-chromium-untrusted/instances/default_instance",
    },
  },
]
```

2. Update your GN args:

```console
gn args out/Default
```

```gn
is_debug = true
symbol_level = 1
blink_symbol_level = 1
v8_symbol_level = 0
enable_nacl = false
use_rtti = true
use_remoteexec = true
use_reclient = false
use_siso = true
```

### Starting a Build ([ref](https://chromium.googlesource.com/chromium/src/+/main/docs/linux/build_instructions.md#Build-Chromium))

```console
autoninja -C out/Default chrome
```

### Listing All Targets

```console
gn ls out/Default
```

### Running Chrome

```console
out/Default/chrome
```

---

## Stacked CLs ([ref](https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools_tutorial.html#_managing_dependent_cls), [commands](https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools.html))

Stacked CLs let you split a large change into smaller, dependent changelists that are reviewed and landed in order.

### Creating a Chain of Branches

```console
# Start the first CL from main
git new-branch first-cl

# ... make changes, commit ...

# Create a second CL on top of the first
git new-branch --upstream-current second-cl

# ... make changes, commit ...

# Create a third CL on top of the second
git new-branch --upstream-current third-cl
```

### Uploading the Stack

Upload from the **root** branch of the stack to upload all dependent CLs:

```console
# Check out the root branch of the stack (use git map-branches -v to find it)

# Upload the current CL and all CLs that depend on it
git cl upload --dependencies
```

### Navigating the Stack

```console
# Move to the parent branch
git nav-upstream

# Move to a child branch
git nav-downstream
```

### Rebasing the Stack

```console
# Rebase only the current stack (not all local branches)
git rebase-update --tree
gclient sync -Df
```

`git rebase-update --tree` re-parents each branch in the current stack onto the latest upstream and drops branches whose commits have already landed.

### Viewing the Branch Tree

```console
git map-branches -v
```

Shows all local branches, their upstream relationships, and behind/ahead counts.

### Re-parenting a Branch

If you need to change a branch's upstream after creation:

```console
# Re-parent onto a specific branch
git reparent-branch <new-parent>

# Re-parent directly onto the root (main/master)
git reparent-branch --root
```

---

## Generating `compile_commands.json` ([ref](https://chromium.googlesource.com/chromium/src/+/master/docs/clangd.md#setting-up))

```console
# Linux / macOS
tools/clang/scripts/generate_compdb.py -p out/Default > compile_commands.json

# PowerShell (requires Python 3)
python tools/clang/scripts/generate_compdb.py -p out/Default | Out-File -Encoding utf8 compile_commands.json
```

---

## Debugging

### Logging ([ref](https://www.chromium.org/for-testers/enable-logging/))

Enable stderr logging at runtime:

```console
out/Default/chrome --enable-logging=stderr --v=-1
```

Add log statements in code:

```cpp
#include "base/logging.h"
// ...
LOG(ERROR) << "YOUR LOG" << YOUR_VARIABLE;
```

### Stack Traces ([ref](https://chromium.googlesource.com/chromiumos/docs/+/master/stack_traces.md#how-to-use-base_stacktrace))

```cpp
#include "base/debug/stack_trace.h"
// ...
LOG(ERROR) << "StackTrace: " << base::debug::StackTrace{};
```

> **Note:** Use `--disable-gpu-sandbox` when debugging the GPU process, or `--no-sandbox` when debugging a renderer process.

---

## Unit Tests

### Running Unit Tests Locally ([ref](https://www.chromium.org/developers/testing/running-tests/#running-basic-tests-gtest-binaries))

1. **Find the test target** for a given source file:

```console
gn refs out/Default --testonly=true --type=executable --all chrome/browser/ui/browser_list_unittest.cc
# Output: //chrome/test:unit_tests
```

2. **Build the test target** (omit the leading `//`):

```console
autoninja -C out/Default chrome/test:unit_tests
```

3. **Run with a filter**:

```console
out/Default/unit_tests --gtest_filter="BrowserListUnitTest.*"
```

---

## Web Tests

### Initial Setup ([ref](https://chromium.googlesource.com/chromium/src/+/main/docs/testing/web_tests.md#Initial-Setup))

```console
autoninja -C out/Default blink_tests
```

### Running Web Tests ([ref](https://chromium.googlesource.com/chromium/src/+/main/docs/testing/web_tests.md#Running-the-Tests))

```console
third_party/blink/tools/run_web_tests.py -t Default
```

### Unskipping Tests ([ref](https://chromium.googlesource.com/chromium/src/+/main/docs/testing/web_test_expectations.md))

The file `third_party/blink/web_tests/TestExpectations` lists all skipped tests. Remove lines ending with `[Failure]` to re-enable them.

### Running a Subset of Tests

> **Caution:** Do not prefix paths with `./` (e.g., use `third_party/blink/...`, not `./third_party/blink/...`).

```console
# Run all fast/forms tests
third_party/blink/tools/run_web_tests.py fast/forms

# Wildcard shorthand
third_party/blink/tools/run_web_tests.py fast/fo*
```

### Running WPT Tests ([ref](https://chromium.googlesource.com/chromium/src/+/main/docs/testing/run_web_platform_tests.md))

```console
third_party/blink/tools/run_wpt_tests.py --target=Default --product=headless_shell external/wpt/html/dom
```

### Local Rebaselining ([ref](https://chromium.googlesource.com/chromium/src/+/main/docs/testing/web_test_expectations.md#Local-manual-rebaselining))

```console
third_party/blink/tools/run_web_tests.py --reset-results foo/bar/test.html
```
