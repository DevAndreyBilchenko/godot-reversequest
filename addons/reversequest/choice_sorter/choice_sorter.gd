extends Node2D

## space between choice nodes
export(int) var gap = 10

var ChoiceDragArea = preload("res://addons/reversequest/choice_sorter/choice_drag_area.tscn")
var ChoiceTween = preload("res://addons/reversequest/choice_sorter/choice_tween.tscn")

var rect setget , _get_rect
var _choice_cached_rect


func _add_area(node):
	var area = ChoiceDragArea.instance()
	
	area.connect("drag", self, "_on_drag", [node, area])
	area.connect("drag_end", self, "_on_drag_end")
	
	node.add_child(area)


func _calc_position(order_index):
	return Vector2(0, (order_index * gap) + (_choice_cached_rect.size.y * order_index))


func _update_order():
	var choices = get_children()
	choices.sort_custom(self, "_y_choice_y_sorter")
	
	for idx in choices.size():
		var ch = choices[idx]
		var res = ch.res
		
		if res.order != idx:
			res.order = idx
			res.emit_changed()
		
		var np = _calc_position(res.order)
		if ch.position != np:
			_tween_to(ch, np)


func _tween_to(node, to):
	var tween = node.get_node_or_null("ChoiceTween")
	
	if not tween:
		tween = ChoiceTween.instance()
		tween.connect("tween_all_completed", self, "_on_tween_completed", [tween])
		node.add_child(tween)
	
	tween.stop(self, "position")
	tween.interpolate_property(node, "position", node.position, to, 0.4)
	
	
	tween.start()


func _choice_y_sorter(a, b):
	return a.position.y < b.position.y


func _get_rect():
	var last_item_pos = _calc_position(get_child_count() - 1)
	
	return Rect2(position, Vector2(_choice_cached_rect.size.x, last_item_pos.y + _choice_cached_rect.size.y))


func _on_tween_completed(tween):
	tween.get_parent().remove_child(tween)
	tween.queue_free()


func _on_child_entered_tree(node):
	_choice_cached_rect = node.rect
	node.position = _calc_position(node.res.order)
	_add_area(node)


func _on_child_exiting_tree(node):
	pass # Replace with function body.


func _on_drag(relative, node, area):
	node.position.y += relative.y

func _on_drag_end():
	_update_order()
