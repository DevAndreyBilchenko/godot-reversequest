extends Node2D

var config = preload("res://addons/reversequest/components/dialog_editor/components/choice/scripts/config.gd")

signal update_order
signal edit_open(res)
signal link(res)
signal link_create(res)


onready var link = $Control/VBoxContainer2/Link
onready var create = $Control/VBoxContainer2/Create


var res
var drag = false
var order_update = false
var collide_with_area
var drag_tween = Tween.new()


func _ready():
	position = calc_position()
	drag_tween.connect("tween_all_completed", self, "_on_drag_tween_all_completed")
	self.connect("update_order", self, "_on_update_order")
	
	if res:
		fill_res()


func set_res(_res):
	res = _res


func fill_res():
	$Control/Label.text = res.text
	$Debug/Code.text = str(res.code)


func calc_position():
	return Vector2(0, res.order * config.size_y + res.order * config.gap)


func get_order():
	return res.order


func set_order(order):
	res.order = order


func move_order(diff):
	res.order += diff


func tween_to(to: Vector2):
	drag_tween.stop(self, "position")
	drag_tween.interpolate_property(self, "position", self.position, to, config.duration)
	
	if not drag_tween.is_inside_tree():
		self.add_child(drag_tween)
		
	drag_tween.start()


func _on_EditTrigger_dbclick():
	emit_signal("edit_open", res)


func _on_OrderTrigger_drag(relative):
	self.position.y += relative.y


func _on_OrderTrigger_drag_start():
	drag = true


func _on_OrderTrigger_drag_end():
	drag = false
	emit_signal("update_order")


func _on_OrderTrigger_area_entered(area):
	if drag == false:
		collide_with_area = area


func _on_OrderTrigger_area_exited(area):
	if collide_with_area == area:
		collide_with_area = null


func _on_Link_pressed():
	emit_signal("link", res)
	link.hide()
	create.show()


func _on_Create_pressed():
	emit_signal("link_create", res)
	create.hide()
	link.show()


func _on_drag_tween_all_completed():
	yield(get_tree(), "idle_frame")
	if not drag_tween.is_active():
		self.remove_child(drag_tween)


func _on_update_order():
	var choice_node = collide_with_area.get_parent()
	var diff = choice_node.position.y - position.y
	var order_update = false
	
	if diff < 0 && diff > config.size_y / 3 * -1:
		set_order(max(0, get_order() - 1))
		choice_node.move_order(1)
		order_update = true
	elif diff > 0 && diff > config.size_y / 3:
		move_order(1)
		collide_with_area.get_parent().slot -= 1
		order_update = true
	
	if order_update:
		var new_pos = calc_position()
		tween_to(new_pos)
