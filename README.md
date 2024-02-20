# zigcurses
A zig library for terminal manipulation.

## Design

The API is divided into three layers. The lowest-level one are is the command layer. 
The commands are essentially just escape sequences sent to the terminal.
On the second layer, the screen commands, we manipulate a Screen struct that contains a buffer
representing the terminal screen. We then render our changes using draw_screen().
On the third layer we work with various UI elements that get translated into screen commands.
This is yet to be implemented.

## Goals

This project was started in order for me to learn about terminal IO and to get better 
at programming in general. I want to create a very simple declarative TUI framework that
can manipulate colors, text, and get user input.
