#!/usr/bin/env python3
# Tests for resurrect-claude-commands: the restore command built from a live
# claude argv, and that zsh splits it back into the intended arguments.
# Run: python3 -B tests/test_resurrect_claude_commands.py
import importlib.machinery
import importlib.util
import pathlib
import shlex
import subprocess
import sys

sys.dont_write_bytecode = True
path = pathlib.Path(__file__).resolve().parent.parent / "resurrect-claude-commands"
loader = importlib.machinery.SourceFileLoader("rcc", str(path))
spec = importlib.util.spec_from_loader("rcc", loader)
rcc = importlib.util.module_from_spec(spec)
loader.exec_module(rcc)

HELP = subprocess.run(["claude", "--help"], capture_output=True, text=True, check=True).stdout
OPTIONS = rcc.parse_option_arities(HELP)
SID = "11111111-2222-3333-4444-555555555555"

# (argv, session id, remote control name, expected command)
CASES = [
    (["claude", "--resume", "EM2", "Overview"], SID, None,
     f"claude --resume {SID}"),
    (["claude", "--remote-control", "--dangerously-skip-permissions", "--name",
      "EM2 & DA Security", "--session-id", SID], SID, None,
     f"claude --remote-control --dangerously-skip-permissions --resume {SID}"),
    (["claude", "--model", "claude-opus-5-5", "--effort", "xhigh", "--name", "cr-pr613",
      "--session-id", SID, "--settings", "/Users/x/review requests/settings.json",
      "Run the `github-cr` skill on PR #613 of Porsenna-ICT/EM3"], SID, None,
     f"claude --model claude-opus-5-5 --effort xhigh --settings '/Users/x/review requests/settings.json' --resume {SID}"),
    (["claude", "--dangerously-skip-permissions", "-r"], SID, None,
     f"claude --dangerously-skip-permissions --resume {SID}"),
    (["claude", "--remote-control", "My RC", "--add-dir", "a", "b", "-c"], SID, None,
     f"claude --remote-control 'My RC' --add-dir a b --resume {SID}"),
    (["claude", "--model=opus", "--name=Foo Bar", "--resume=EM2 Overview", "--", "hello"], SID, None,
     f"claude --model=opus --resume {SID}"),
    (["/Users/lubos/.local/bin/claude", "-n", "x", "-w", "feat", "--fork-session", "fix it"], SID, None,
     f"claude --resume {SID}"),
    (["claude", "--dangerously-skip-permissions", "--resume", "EM2", "Overview"], None, None,
     "claude --dangerously-skip-permissions"),
    (["claude", "--dangerously-skip-permissions"], SID, "EM2 Overview",
     f"claude --dangerously-skip-permissions --remote-control 'EM2 Overview' --resume {SID}"),
    (["claude", "--remote-control", "--dangerously-skip-permissions"], SID, "EM2 Overview",
     f"claude --remote-control --dangerously-skip-permissions --resume {SID}"),
    (["claude", "--remote-control=Old", "-r"], SID, "New",
     f"claude --remote-control=Old --resume {SID}"),
]

failed = 0
for argv, sid, remote, expected in CASES:
    got = rcc.restore_command(argv, sid, OPTIONS, remote)
    if got != expected:
        failed += 1
        print(f"FAIL {argv}\n  expected: {expected}\n  got:      {got}")
    shell_argv = subprocess.run(
        ["zsh", "-fc", "print -rl -- " + got.removeprefix("claude").lstrip()],
        capture_output=True, text=True).stdout.splitlines()
    if shell_argv != shlex.split(expected)[1:]:
        failed += 1
        print(f"FAIL zsh word split for {got!r}: {shell_argv}")

print(f"{len(CASES)}/{len(CASES)} ok" if not failed else f"{failed} failure(s)")
sys.exit(1 if failed else 0)
