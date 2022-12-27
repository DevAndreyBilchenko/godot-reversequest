extends Control

## space between choice nodes
export(int) var gap = 8

var ChoiceTween = preload("res://addons/reversequest/choice_sorter/choice_tween.tscn")

var drag_node
var _choice_cached_size_y


func _add_area(node):
	node.connect("gui_input", self, "_on_node_gui_input", [node])


func _calc_position(order_index):
	return Vector2(0, (order_index * gap) + (_choice_cached_size_y * order_index))


func _update_order():
	var choices = get_children()
	var has_changed = false
	choices.sort_custom(self, "_choice_y_sorter")
	
	for idx in choices.size():
		var ch = choices[idx]
		var res = ch.res
		
		if res.order != idx:
			res.order = idx
			res.emit_changed()
			has_changed = true
		
		var np = _calc_position(res.order)
		if ch != drag_node && ch.rect_position != np:
			_tween_to(ch, np)
			
	if has_changed:
		#controller emit sctucture
		pass


func _tween_to(node, to):
	var tween = node.get_node_or_null("ChoiceTween")
	
	if not tween:
		tween = ChoiceTween.instance()
		tween.connect("tween_all_completed", self, "_on_tween_completed", [tween])
		node.add_child(tween)
	
	tween.stop(self, "position")
	tween.interpolate_property(node, "rect_position", node.rect_position, to, 0.4 - tween.tell())
	
	tween.start()


func _choice_y_sorter(a, b):
	return a.rect_position.y < b.rect_position.y


func _on_tween_completed(tween):
	tween.get_parent().remove_child(tween)
	tween.queue_free()


func _on_child_entered_tree(node):
	_choice_cached_size_y = node.rect_size.y
	node.rect_position = _calc_position(node.res.order)
	_add_area(node)

	rect_min_size.y = node.rect_position.y + _choice_cached_size_y


func _on_child_exiting_tree(_node):
	for ch in get_children():
		ch.rect_position = _calc_position(ch.res.order)


func _on_node_gui_input(input, node):
	if input is InputEventMouseMotion and input.button_mask == BUTTON_MASK_LEFT:
		node.rect_position.y += input.relative.y
		_update_order()
		accept_event()
	
	if input is InputEventMouseButton:
		if input.pressed and input.doubleclick == false:
			drag_node = node
			accept_event()
		elif drag_node != null:
			drag_node = null
			_update_order()
			accept_event()
