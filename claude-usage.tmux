#!/usr/bin/env bash
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Expose a status-format snippet without mutating the status bar.
tmux set -g @claude-usage "#($CURRENT_DIR/bin/tmux-claude-usage status)"
tmux set -g @claude-usage-savings "#($CURRENT_DIR/bin/tmux-claude-usage savings-status)"

# Opt-in: a key that opens the local-model savings report in a popup.
key="$(tmux show-option -gqv @claude-usage-savings-key)"
if [ -n "$key" ]; then
  tmux bind-key "$key" display-popup -E -w 56 -h 19 \
    "bash -c '\"$CURRENT_DIR/bin/tmux-claude-usage\" savings; read -rsn1'"
fi
