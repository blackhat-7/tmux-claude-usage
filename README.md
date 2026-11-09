# tmux-claude-usage

Your Claude Code usage limits, in the tmux status bar.

```
✳ 5h ━━━━━╸──── 58% ↻2h13m · 7d ━╸──────── 14% ↻3d04h
```

Two gauges: the 5-hour session window and the 7-day window. Each is a line that
fills in half-cell steps and heats from green to red along its length; the
percentage turns yellow at 60% and red at 85%. `↻` counts down to that window's
reset — `2h13m` under a day, `3d04h` beyond it. A window that has already lapsed
shows no countdown, so the `5h` clock appears only while a session is actually
open.

Every field is padded, so the segment holds a constant 55 columns and your
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

## Local model savings (optional)

If you route some Claude Code subagents to a local model (for example with a
proxy that sends non-Claude model names to llama.cpp or Ollama),
`tmux-claude-usage savings` shows what that work would have cost on Claude,
today and over 7 days, 30 days and all time, with a 14-day sparkline:

```
  ⌂ LOCAL MODEL SAVINGS         at Claude API prices

  38% cheaper than all-Claude, all time  ·  86 subagents ran locally

            % saved             saved       paid
  today     ━━━━╸─────   38%    $1.53      $2.44
  ...
```

It reads Claude Code's transcripts (`~/.claude/projects`) and counts sessions
whose main agent ran on Claude. Each subagent that ran on a non-Claude model is
priced at Claude API list prices as the model it was asked for (`haiku`,
`sonnet`, ...), or the main agent's model when it named none. "On Claude" is
"Paid" is what those sessions spent on Claude models, and "% saved" is saved out
of saved plus paid: how much less the work cost than if Claude had done all of
it. These are API-price estimates, not your subscription's bill.

`#{@claude-usage-savings}` (or `tmux-claude-usage savings-status`) puts the last
7 days' percentage in the status bar, `⌂ 38% saved 7d`. It reads a cache refreshed in
the background every `CLAUDE_USAGE_SAVINGS_TTL` seconds (default `300`), and
stays empty until a local subagent has saved something.

To open the full report in a popup, pick a key before the plugin loads:

```tmux
set -g @claude-usage-savings-key u   # prefix + u
```

## License

MIT
