# tmux-claude-usage

Your Claude Code usage limits, in the tmux status bar.

```
✳ 5h ▰▰▰▱▱  58% ↻2h13m │ 7d ▰▱▱▱▱  14% ↻3d04h
```

Two gauges: the 5-hour session window and the 7-day window, each coloured green
→ yellow (60%) → red (85%). `↻` counts down to that window's reset — `2h13m`
under a day, `3d04h` beyond it. A window that has already lapsed shows no
countdown, so the `5h` clock appears only while a session is actually open.

Every field is padded, so the segment holds a constant 45 columns and your
status bar never jitters as the numbers change.

Numbers come from the same `/usage` endpoint Claude Code uses, so they match
exactly.

## How it works

`tmux-claude-usage status` prints a cached reading instantly and kicks off a
background refresh when the cache is older than 60s. tmux redraws the status bar
on its own `status-interval`, so the gauges stay current with no daemon and no
blocking network call in your status line.

Auth comes from Claude Code's own OAuth token — the macOS keychain, or
`~/.claude/.credentials.json` elsewhere. Nothing to configure. If no token is
found the segment renders empty, leaving your status bar untouched.

## Requirements

`tmux`, `curl`, `jq`, and a Claude Pro/Max subscription logged in via
`claude /login`.

## Install

### Nix flake

```nix
inputs.tmux-claude-usage.url = "github:blackhat-7/tmux-claude-usage";
```

```nix
programs.tmux.plugins = [ inputs.tmux-claude-usage.packages.${pkgs.system}.default ];
```

### TPM

```tmux
set -g @plugin 'blackhat-7/tmux-claude-usage'
```

## Use

The plugin sets `@claude-usage` and otherwise leaves your config alone. Drop it
wherever you like:

```tmux
set -g status-right "#{@claude-usage} #h"
set -g status-interval 15
```

Or call the binary directly:

```tmux
set -g status-right "#(tmux-claude-usage status) #h"
```

## Configure

| Variable            | Default | Meaning                    |
| ------------------- | ------- | -------------------------- |
| `CLAUDE_USAGE_TTL`  | `60`    | Cache lifetime, in seconds |

## License

MIT
