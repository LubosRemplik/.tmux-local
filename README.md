## Cheat sheet

Prefix is set to `Ctrl + S` i.e. send-prefix for now, was not able to set it to `Ctrl + ,` which I prefer.

### Basics

- `<prefix> + :` enter command mode (even when using vi mode most of the time, after [strong suggestions](https://github.com/tmux-plugins/tmux-sensible#options), status-keys are set to emacs. See `man tmux` emacs for more info
- `tmux list-commands` list all supported commands
- `<prefix> + r` reload configuration (configuration reloaded and plugins installed also on tmux start)

### Sessions

- `tattach` bash script to start session named by current directory or attach if exists. 
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

- `<prefix> + c` or `<prefix> + n` open new window 
- `<prefix> + w` list windows
- `<prefix> + ,` rename window (it is good to rename long-term windows)
- `<prefix> + j` and  `<prefix> + k`  move to next / previous window
- `<prefix> + 0..9` go to window by number (note command `:swap-window -t <position>` for moving windows around
- `<prefix> + &` close full window, maybe better to use `<prefix> + x` to close pane, when last pane is closed => window is closed

### Panes

- `<prefix> + q` to show pane numbers and when pressing in 5s, it switches the pane
- `<prefix> + \` horizontal split
- `<prefix> + -` vertical split
- `C-k` move up ^1,
- `C-j` move down ^1,
- `C-h` move left ^1,
- `C-l` move right ^1,
- `<prefix> + z` zoom pane
- `<prefix> + x` kill pane

^1 when Vim is opened it works with its panes too, requires `vim-tmux-navigator`

### Copy mode

Copy mode uses vi commands for movement

- `<prefix> + [` enter copy mode
- `v` for visual select 
- `y` or `Enter` to execute copy mode

## Install

Using [this config](https://github.com/gpakosz/.tmux/) + sourcing local which can be founded in this repo

1.	Follow instructions [here](https://github.com/gpakosz/.tmux/)

1.	In home directory `ln -s ~/.tmux-local/.tmux.conf.local`

1.	Bash script helping with `tmux attach` command,   
Go to `bin` directory and symlink `ln -s ~/.tmux-local/tattach` 

1.	Bash script copying=yanking text to clipboard over terminal with remote,   
Go to `bin` directory and symlink `ln -s ~/.tmux-local/yank` 

1.	When using mosh, build from [this PR](https://github.com/mobile-shell/mosh/pull/1104) if not merged to support copy mode 

1.  Make sure `$EDITOR`, `$VISUAL` and `$TERM` are set.  
	In `.bashrc`
    ```
	export EDITOR='vi -e'
	export VISUAL='vim'
	export TERM='xterm-256color'

    ```

1.	Bash script for displaying tmux bell,   
Go to `bin` directory and symlink `ln -s ~/.tmux-local/tbell`   
For usage see .tmux.conf.local

### To consider

not installed yet

-	More advanced sessions control https://github.com/tmux-plugins/tmux-sessionist
