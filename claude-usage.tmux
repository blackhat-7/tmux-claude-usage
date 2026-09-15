#!/usr/bin/env bash
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Expose a status-format snippet without mutating the status bar.
tmux set -g @claude-usage "#($CURRENT_DIR/bin/tmux-claude-usage status)"
