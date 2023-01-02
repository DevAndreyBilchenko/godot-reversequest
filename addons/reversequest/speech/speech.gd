extends Control

signal connections_changed

export(NodePath) var actor_edit_np
export(NodePath) var choice_container_np
export(NodePath) var sizer_np

var res

var size_x setget ,_get_size_x
var size_y setget ,_get_size_y

var _controller
var _class_list
var _actor_edit
var _choice_container
var _sizer


func _ready():
	_actor_edit = get_node(actor_edit_np)
	_choice_container = get_node(choice_container_np)
	_sizer = get_node(sizer_np)
	_actor_edit.connect("action_started", self, "_on_actor_edit_action_started")


func setup(speech_res, class_list):
	_class_list = class_list
	res = speech_res
	_controller = class_list.dialog_res_controller
	_choice_container.class_list = class_list
	
	for ch in _controller.get_choice_list(res.code):
		add_choice(ch)


func add_choice(choice_res):
	var choice = preload("res://addons/reversequest/choice/choice.tscn")
	var choice_node = choice.instance()

	if (choice_res != null):
		choice_node.setup(choice_res, _class_list, res.code)

	_choice_container.add_child(choice_node)

	choice_node.name = get_choice_node_name(choice_node.res.code)


func find_choice_node(choice_code):
	return _choice_container.get_node_or_null(get_choice_node_name(choice_code))


func get_choice_node_rect(choice_code):
	var choice = find_choice_node(choice_code)
	return Rect2(choice.rect_global_position, choice.rect_size)


func get_choice_node_name(_code):
	return str("Coice_code_", _code)


func emit_connections_changed():
	emit_signal("connections_changed")

func _get_size_y():
	return _sizer.rect_size.y


func _get_size_x():
	return _sizer.rect_size.x


func _on_choice_add_pressed():
	var choice_res = _controller.create_choice(res.code)
	add_choice(choice_res)


func _on_actor_edit_action_started():
	 _actor_edit.send_data = [res]
