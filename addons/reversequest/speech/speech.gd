extends Control

var _controller
var res

var size_x setget ,_get_size_x
var size_y setget ,_get_size_y

onready var _actor_edit = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Edit/SceneSwitcherActorEdit
onready var _choice_container = $VBoxContainer/ChoiceContainer


func _ready():
	_actor_edit.connect("action_started", self, "_on_actor_edit_action_started")


func setup(speech_res, controller):
	res = speech_res
	_controller = controller
	
	for ch in speech_res.choice_list:
		add_choice(ch)


func add_choice(choice_res):
	var choice = preload("res://addons/reversequest/choice/choice.tscn")
	var choice_node = choice.instance()

	if (choice_res != null):
		choice_node.setup(choice_res, _controller)

	_choice_container.add_child(choice_node)

	choice_node.name = get_choice_node_name(choice_node.res.code)


func find_choice_node(choice_code):
	return get_node_or_null(str("ChoiceContainer/", get_choice_node_name(choice_code)))


func get_choice_node_rect(choice_code):
	var choice = find_choice_node(choice_code)
	return Rect2(choice.global_position, Vector2(choice.size_x, choice.size_y))


func get_choice_node_name(_code):
	return str("Coice_code_", _code)


func _get_size_y():
	return rect_size.y


func _get_size_x():
	return rect_size.x


func _on_choice_add_pressed():
	var choice_res = _controller.create_choice(res.code)
	add_choice(choice_res)


func _on_actor_edit_action_started():
	 _actor_edit.send_data = [res]
