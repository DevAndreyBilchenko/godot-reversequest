extends Control

signal connections_changed

export(NodePath) var actor_edit_np
export(NodePath) var choice_container_np
export(NodePath) var sizer_np
export(NodePath) var movable_np
export(NodePath) var remove_button_np

var state_list = preload("res://addons/reversequest/choice/choice_state_list.gd").new()

var res

var size_x setget ,_get_size_x
var size_y setget ,_get_size_y

var _controller
var _class_list
var _actor_edit
var _choice_container
var _sizer
var _movable
var _tween = Tween.new()
var _remove_button


func setup(speech_res, class_list):
	if not is_inside_tree():
		yield(self, "tree_entered")
	
	_actor_edit = get_node(actor_edit_np)
	_choice_container = get_node(choice_container_np)
	_sizer = get_node(sizer_np)
	_movable = get_node(movable_np)
	_remove_button = get_node(remove_button_np)
	_actor_edit.connect("action_started", self, "_on_actor_edit_action_started")
	_tween.connect("tween_all_completed", self, "_on_tween_done")
	
	_class_list = class_list
	res = speech_res
	_controller = class_list.dialog_res_controller
	_choice_container.class_list = class_list
	
	state_list.connect("deletable_changed", self, "_on_state_list_deletable_changed")
	
	for ch in _choice_container.get_children():
		ch.queue_free()
	
	for ch in _controller.get_choice_list(res.code):
		_add_choice(ch)
		
	_update_deletable_state()


func move_to(position):
	if not _tween.is_inside_tree():
		add_child(_tween)
	
	var save_pos = rect_global_position
	rect_position = position
	
	_tween.stop_all()
	_tween.interpolate_property(_movable, "rect_global_position", save_pos, rect_position, 0.35)
	_tween.start()


func get_choice_out_y_position(order):
	return _choice_container.rect_position.y + (_choice_container.calc_position(order) + Vector2(0, _choice_container.choice_cached_size_y / 2)).y


func find_choice_node(choice_code):
	return _choice_container.get_node_or_null(get_choice_node_name(choice_code))


func get_choice_node_rect(choice_code):
	var choice = find_choice_node(choice_code)
	return Rect2(choice.rect_global_position, choice.rect_size)


func get_choice_node_name(_code):
	return str("Coice_code_", _code)


func emit_connections_changed():
	emit_signal("connections_changed")


func _add_choice(choice_res):
	var choice = preload("res://addons/reversequest/choice/choice.tscn")
	var choice_node = choice.instance()

	if (choice_res != null):
		choice_node.setup(choice_res, _class_list, res.code)

	_choice_container.add_child(choice_node)

	choice_node.name = get_choice_node_name(choice_node.res.code)
	
	choice_node.state_list.connect("deletable_changed", self, "_on_choice_state_list_deletable_changed", [choice_node])


func _update_deletable_state():
	if res.code == 0:
		state_list.deletable = false
		return
	
	var deletable = true
	
	for choice in _choice_container.get_children():
		if not choice.state_list.deletable:
			deletable = false
			break
			
	state_list.deletable = deletable


func _get_size_y():
	return _sizer.rect_size.y


func _get_size_x():
	return _sizer.rect_size.x


func _on_choice_add_pressed():
	var choice_res = _controller.create_choice(res.code)
	_add_choice(choice_res)
	yield(get_tree(), "idle_frame")
	_controller.emit_structure_update()


func _on_actor_edit_action_started():
	 _actor_edit.send_data = [res]


func _on_tween_done():
	remove_child(_tween)


func _on_state_list_deletable_changed():
	_remove_button.visible = state_list.deletable


func _on_choice_state_list_deletable_changed(choice_node):
	_update_deletable_state()
