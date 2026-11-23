#!/usr/bin/env bash
# Install a custom Claude Code status line.
#
# This is not a skill. It lives in this directory because it changes how Claude Code
# looks. It shows one line at the bottom of the Claude Code interface:
#
#     <directory> <git branch> <model> context:N%
#
# For example: `paulrougieux.github.io master Opus 5.5 context:12%`
#
# What the script does:
#
# 1. Writes a small helper script to ~/.claude/statusline.sh. Claude Code runs this
#    helper and sends it session information as JSON on stdin. The helper reads the
#    model name, the current directory and the context window usage from that JSON,
#    asks git for the current branch (the branch is left out outside a git repository)
#    and prints the status line.
# 2. Makes the helper executable.
# 3. Adds a "statusLine" entry to ~/.claude/settings.json that points to the helper.
#    Other settings already in that file are kept. An existing "statusLine" entry is
#    replaced.
#
# Usage: bash claude_code_status_line.sh   (needs python3; git optional)
# Then restart Claude Code to see the new status line.
set -euo pipefail
mkdir -p ~/.claude
cat > ~/.claude/statusline.sh <<'EOF'
#!/usr/bin/env bash
# Claude Code status line: shows directory, git branch, model name and context window usage
python3 -c '
import json, os, sys, subprocess
try:
    d = json.load(sys.stdin)
except Exception:
    d = {}
model = (d.get("model") or {}).get("display_name") or "?"
cwd = (d.get("workspace") or {}).get("current_dir") or d.get("cwd") or "."
try:
    branch = subprocess.run(["git", "-C", cwd, "branch", "--show-current"],
                            capture_output=True, text=True, timeout=2).stdout.strip()
except Exception:
    branch = ""
p = (d.get("context_window") or {}).get("used_percentage")
ctx = "context:--%" if p is None else f"context:{round(p)}%"
parts = [os.path.basename(os.path.abspath(cwd))] + ([branch] if branch else []) + [model, ctx]
print(" ".join(parts))
'
EOF
chmod +x ~/.claude/statusline.sh
python3 - <<'EOF'
import json, os
p = os.path.expanduser("~/.claude/settings.json")
s = json.load(open(p)) if os.path.exists(p) and os.path.getsize(p) else {}
s["statusLine"] = {"type": "command", "command": "~/.claude/statusline.sh"}
with open(p, "w") as f:
    json.dump(s, f, indent=2); f.write("\n")
EOF
echo "Status line installed. Restart Claude Code to see it."
