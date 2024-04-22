extends CanvasLayer

class_name Console

@export var is_console_visible: bool = true

static var consoleRt: RichTextLabel
var cmd_input: LineEdit

static var _commands: Dictionary

var _command_history: Array[String] = []
var _command_from_history_index = -1

func _ready():
	consoleRt = get_node('Container/VBoxContainer/ConsoleRt')
	cmd_input = get_node('Container/VBoxContainer/Cmd')
	show() if is_console_visible else hide()
	_create_toggle_key()
	
	_commands = {
		'help': {
			'description': 'Show all the commands',
			'exec': _help,
			'param_types': []
		},
		'clear': {
			'description': 'Clear the console',
			'exec': _clear,
			'param_types': []
		}
	}

func _create_toggle_key():
	var input_event = InputEventKey.new()
	input_event.set_keycode(KEY_QUOTELEFT)
	InputMap.add_action('toggle_console')
	InputMap.action_add_event('toggle_console', input_event)

func _process(delta):
	if Input.is_action_just_pressed('toggle_console'):
		if visible:
			hide()
		else:
			show()
			cmd_input.set_text('')
			cmd_input.grab_focus.call_deferred()
			

	if cmd_input.has_focus():
		if Input.is_action_just_pressed('ui_text_completion_accept'):
			_exec()
		elif Input.is_action_just_pressed('ui_up'):
			_get_command_from_history(1)
		elif Input.is_action_just_pressed('ui_down'):
			_get_command_from_history(-1)

static func add_command(_name: String, exec: Callable, param_types: Array[String]=[], description: String = ''):
	_commands[_name] = {
		'description': description,
		'exec': exec,
		'param_types': param_types
	}

static func remove_command(_name: String):
	_commands.erase(_name)

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
	consoleRt.append_text(_text)

func _exec():
	var command: String = cmd_input.get_text()
	cmd_input.set_text('')
	_command_from_history_index = -1
	
	var cmdArr: PackedStringArray = command.split(' ')
	
	if cmdArr.size() and _commands.has(cmdArr[0]):
		var cmdParams = []
		for param_i in range(1, cmdArr.size()):
			# param is string by default
			var param = cmdArr[param_i]
			if _commands[cmdArr[0]].param_types.size() > 0:
				match _commands[cmdArr[0]].param_types[param_i - 1]:
					'int':
						param = int(cmdArr[param_i])
					'float':
						param = float(cmdArr[param_i])
					'bool':
						param = true if ['1', 'true', 'TRUE', 'True'].has(cmdArr[param_i]) else false
			cmdParams.append(param)
		
		Console.print('>', command)
		(_commands[cmdArr[0]].exec as Callable).callv(cmdParams)
		
	elif cmdArr[0] != '':
		Console.print('>', command, '[color=#d15d5d]', 'command not found.', '[/color]')
		
	if command != '' and (_command_history.size() == 0 or command != _command_history[0]):
		_command_history.push_front(command)

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
		var params = ''
		for param: String in _commands[command].param_types as Array[String]:
			params += '['+param+'] '
		Console.print('[color=#62b769]', command, params, '[/color]', '-', _commands[command].description)
	Console.print('---------------------')

func _clear():
	consoleRt.clear()
