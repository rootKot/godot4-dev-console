# Dev Console for Godot 4.x

Hey there! Check out this handy in-game dev console I made for Godot. It's super easy to set up and perfect for debugging multiplayer games.

You know how the built-in console kinda jumbles everything together? Well, mine separates the console outputs for each instance, making multiplayer debugging way easier.

Give it a try and see how much smoother your development process can be!

![Screenshot1](Screenshot1.PNG)


## Features

- Simple setup and usage
- Toggle the console with the press of the ` key
- Navigate previous commands with ease using the arrow keys
- Define custom commands for your game (Currently in Development)

## Installation

* Add the repo as a submodule anywhere in your project

```bash
  git submodule add git@github.com:rootKot/godot4-dev-console.git
```
Now you will have `Console.tscn` in that `godot4-dev-console` folder
* Drag and drop the `Console.tscn` inside your scene node.
From the inspector you can set is the console should be visible by default when runing the project

## Usage

* Use `~` key to open/close the console (It is actually ` key)
* Type `help` and press Enter, to see available commands
* For printing something in the console use Console.print() instead of print()
```gdscript
  Console.print('Hello world')
  Console.print('This is my variable', my_variable)
  Console.print('I', 'can', 'pass', 'up', 'to', 12, 'params')
```
## Future plans
* Let user to add custom commands
* Add checkbox to select if the console should be available in release build

## License
### MIT License
Copyright © 2024 rootKot
