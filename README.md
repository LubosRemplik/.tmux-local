## Cheat sheet

Prefix is set to `Ctrl + S` i.e. send-prefix for now, was not able to set it to `Ctrl + ,` which I prefer.

### Basics

- `<prefix> + :` enter command mode. Even when using vi mode most of the time, after [strong suggestions](https://github.com/tmux-plugins/tmux-sensible#options), status-keys are set to emacs. See `man tmux` emacs for more info
- `tmux list-commands` list all supported commands
- `<prefix> + r` and/or `<prefix> + I` reload configuration (configuration reloaded and plugins installed also on tmux start)

### Sessions

- `tattach` bash script to start session named by current directory or attach if exists. 
- `<prefix> + C` prompt for creating a new session by name.
- `:new -As mysession` or `tmux new -As mysession` start new session or attach if exists. 
- `<prefix> + @` - promote current pane into a new session.
- `<prefix> + s` or `tmux ls` list sessions
- `<prefix> + w` list sessions with windows
- `<prefix> + $` rename session 
- `<prefix> + S` switches to the last session.
- `<prefix> + (` and `<prefix> + )` move previous / next session
- `<prefix> + X` kill current session without detaching tmux.
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
- `<prefix> + {` and/or `<prefix> + }` swap panes left/right

^1 when Vim is opened it works with its panes too, requires `vim-tmux-navigator`

### Copy mode

Copy mode uses vi commands for movement

- `<prefix> + [` enter copy mode
- `v` for visual select 
- `y` or `Enter` to execute copy mode

## Install

Use `git clone https://github.com/LubosRemplik/.tmux-local ~/.tmux-local` + `./install` bash script and/or follow instructions below

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

1.	Bash script for easy tmuxinator start and stop, go to `bin` directory and do symlinks  
	`ln -s ~/.tmux-local/.tmux.conf.local`  
	`ln -s ~/.tmux-local/.tmux.conf.local`  

## To consider, resources, learning

This is not used/installed yet

-	More advanced sessions control https://github.com/tmux-plugins/tmux-sessionist
-	Having tmux configurations (windows, panes, ...) per project = quick start https://github.com/tmuxinator/tmuxinator
-	Watch plugins https://github.com/tmux-plugins
-	Official wiki, repo https://github.com/tmux/tmux/wiki
-	Nice video tutorials https://thoughtbot.com/upcase/tmux 
-	Widely used configuraiton + issues with problems solved before https://github.com/gpakosz/.tmux
