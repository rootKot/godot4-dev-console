extends CanvasLayer

class_name Console

@export var is_console_visible: bool = true

static var consoleRt: RichTextLabel
var cmd_input: LineEdit

var _commands: Dictionary = {
	'help': {
		'description': 'Show all the commands',
		'exec': _help
	},
	'clear': {
		'description': 'Clears the console',
		'exec': _clear
	}
}

var _command_history: Array[String] = []
var _command_from_history_index = -1

func _ready():
	consoleRt = get_node('Container/VBoxContainer/ConsoleRt')
	cmd_input = get_node('Container/VBoxContainer/Cmd')
	show() if is_console_visible else hide()
	_create_toggle_key()

func _create_toggle_key():
	var input_event = InputEventKey.new()
	input_event.set_keycode(KEY_QUOTELEFT)
	InputMap.add_action('toggle_console')
	InputMap.action_add_event('toggle_console', input_event)

func _process(delta):
	if Input.is_action_just_pressed('toggle_console'):
		hide() if visible else show()
		cmd_input.set_text('')
	
	if cmd_input.has_focus():
		if Input.is_action_just_pressed('ui_accept'):
			_exec()
		elif Input.is_action_just_pressed('ui_up'):
			_get_command_from_history(1)
		elif Input.is_action_just_pressed('ui_down'):
			_get_command_from_history(-1)

static func print(
	arg0 = null, arg1 = null, arg2 = null, arg3 = null,
	arg4 = null, arg5 = null, arg6 = null, arg7 = null,
	arg8 = null, arg9 = null, arg10 = null, arg11 = null
):
	var args = [arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11]
	var _text:String = '\n'
	for arg in args:
		if arg == null:
			break
		_text += str(arg) + ' '
	consoleRt.add_text(_text)

func _exec():
	var _text: String = cmd_input.get_text()
	cmd_input.set_text('')
	_command_from_history_index = -1
	
	if _text != '' and _commands.has(_text):
		Console.print('>', _text)
		_commands[_text].exec.call()
		_command_history.push_front(_text)
	elif _text != '':
		Console.print('>', _text, 'command not found.')

func _get_command_from_history(direction: int):
	var history_size: int = _command_history.size()
	if _command_from_history_index >= -1 and _command_from_history_index < history_size:
		_command_from_history_index = clampi(_command_from_history_index + direction, -1, history_size - 1)
		if _command_from_history_index == -1:
			cmd_input.set_text('')
		else:
			cmd_input.set_text(_command_history[_command_from_history_index])
		

func _help():
	Console.print('---------------------')
	for command in _commands:
		Console.print(command, '-', _commands[command].description)
	Console.print('---------------------')

func _clear():
	consoleRt.clear()
