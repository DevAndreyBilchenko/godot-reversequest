extends Node2D


signal speech_edit(speech_res)
signal speech_remove(speech_res)
signal choice_edit(speech_res, choice_res)
signal choice_update_order(speech_res)
signal choice_link(speech_res, choice_res)
signal choice_link_create(speech_res, choice_res)
signal linked(speech_res)

var _controller
var _res

var size_x setget ,_get_size_x
var size_y setget ,_get_size_y
var base_y = 308
var bottom = 0

onready var _actor_edit = $Control/VBoxContainer/Edit/SceneSwitcherActorEdit


func _ready():
	update_choice_line()
	_actor_edit.connect("action_started", self, "_on_actor_edit_action_started")


func setup(speech_res, controller):
	_res = speech_res
	_controller = controller
	
	_res.connect("changed", self, "_on_res_changed")
	
	update()
	
	for ch in speech_res.choice_list:
		add_choice(ch)


func enable_link_zone():
	$LinkZone.show()


func disable_link_zone():
	$LinkZone.hide()


func add_choice(choice_res):
	var choice = preload("res://addons/reversequest/choice/choice.tscn")
	var choice_container = get_node("ChoiceContainer")
	var choice_node = choice.instance()
	
	choice_node.connect("update_order", self, "_on_choice_update_order")
	choice_node.connect("link", self, "_on_choice_link")
	choice_node.connect("link_create", self, "_on_choice_link_create")

	if (choice_res != null):
		choice_node.setup(choice_res, _controller)

	choice_container.add_child(choice_node)

	choice_node.name = get_choice_node_name(choice_node.res.code)
	
	update_choice_line()


func update_choice_line():
	var choice_container = get_node("ChoiceContainer")
	var choice_line = get_node("ChoiceLine")
	var choice_add = get_node("ChoiceAdd")
	var index = choice_container.get_child_count()
	var base_x = choice_line.get_point_position(0).x
	
	if index == 0:
		choice_line.set_point_position(1, Vector2(base_x, base_y + 20))
		choice_add.rect_position = Vector2(2, base_y + 26)
		bottom = base_y + 26
	else:
		var item_y = choice_container.get_child(index-1).position.y + choice_container.position.y
		choice_line.set_point_position(1, Vector2(base_x, item_y + 45))
		choice_add.rect_position = Vector2(2, item_y + 51)
		bottom = item_y + 51


func find_choice_node(choice_code):
	return get_node_or_null(str("ChoiceContainer/", get_choice_node_name(choice_code)))


func get_choice_node_rect(choice_code):
	var choice = find_choice_node(choice_code)
	return Rect2(choice.global_position, Vector2(choice.size_x, choice.size_y))


func get_choice_node_name(_code):
	return str("Coice_code_", _code)


func update():
	$Control/Text.text = _res.text


func _get_size_y():
	return bottom + 50


func _get_size_x():
	var sizer = $Control
	return sizer.rect_size.x
	

func _on_choice_add_pressed():
	var choice_res = _controller.create_choice(_res.code)
	add_choice(choice_res)


func _on_Edit_pressed():
	emit_signal("speech_edit", _res)


func _on_Remove_pressed():
	emit_signal("speech_remove", _res)


func _on_choice_update_order():
	emit_signal("choice_update_order", _res)


func _on_choice_link(choice_res):
	emit_signal("choice_link", _res, choice_res)


func _on_choice_link_create(choice_res):
	emit_signal("choice_link_create", _res, choice_res)


func _on_LinkZone_pressed():
	emit_signal("linked", _res)


func _on_res_changed():
	update()


func _on_actor_edit_action_started():
	 _actor_edit.send_data = [_res]
