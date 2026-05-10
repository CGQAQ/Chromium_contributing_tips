###############################################################
# Editor
export EDITOR=vim

# Google
export PATH=/home/cg/google/depot_tools:$PATH
alias cnwd="gclient-new-workdir.py --use-git-worktree --copy-on-write"

alias gs="gclient sync -DRf"
alias b="autoninja -C out/Default chrome"
alias br="autoninja -C out/Release chrome"
alias bb="autoninja -C out/Default blink_tests"
alias wpt="./third_party/blink/tools/run_web_tests.py -t Default"
