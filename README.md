## Cheat sheet

Prefix is set to `Ctrl + S` i.e. send-prefix for now, was not able to set it to `Ctrl + ,` which I prefer.

### Basics

- `<prefix> + :` enter command mode
- `<prefix> + [` enter copy mode, use vi commands for movement, `v` for visual select and `y` or `Enter` to execute copy mode
- `tmux list-commands` list all supported commands

### Sessions

- `tat` bash script to start session named by current directory or attach if exists. 
- `:new -As mysession` or `tmux new -As mysession` start new session or attach if exists. 
- `<prefix> + s` or `tmux ls` list sessions
- `<prefix> + w` list sessions with windows
- `<prefix> + $` rename session 
- `<prefix> + (` and `<prefix> + )` move previous / next session
- `tmux kill-session -t mysession` to kill session
- `tmux kill-session -a` kill all session but the current (note session is killed when exited until last one)
- `<prefix> + d` detach client (exit and leave tmux running)
- `tmux a -t mysession` attach session

### Windows

### Panes

### Others

## Install

Using [this config](https://github.com/gpakosz/.tmux/) + sourcing local which can be founded in this repo

1.	Follow instructions [here](https://github.com/gpakosz/.tmux/)

1.	In home directory `ln -s ~/.tmux-local/.tmux.conf.local`

1.	There is bash script which is helping with `tmux attach` command,   
Go to `bin` directory and symlink `ln -s ~/.tmux-local/tat` 

1.	Another executable scipt for copying=yanking text (vim) to clipboard over terminal with remote,   
Go to `bin` directory and symlink `ln -s ~/.tmux-local/yank` 

1.	When using mosh, build from [this PR](https://github.com/mobile-shell/mosh/pull/1104) if not merged to support copy mode 

1.  Make sure `$EDITOR`, `$VISUAL` and `$TERM` are set.  
	In `.bashrc`
    ```
	export EDITOR='vi -e'
	export VISUAL='vim'
	export TERM='xterm-256color'

    ```
