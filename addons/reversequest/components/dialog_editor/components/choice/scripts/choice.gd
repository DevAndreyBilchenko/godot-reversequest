extends Node2D

signal update_order
signal edit_open(res_code)
signal link(res_code)
signal link_create(res_code)

onready var link = $Control/VBoxContainer2/Link
onready var create = $Control/VBoxContainer2/Create

var res = {
	"code": "", 
	"text": ""
}
var code = -1
var size_y = 50
var size_x = 300
var drag = false
var order_update = false
var collide_with_area
var speed = 250
var slot = 0
var gap = 10

func set_res(_res):
	code = _res.code
	res = _res
	
func fill_res():
	$Control/Label.text = res.text
	$Debug/Code.text = str(code)

func calc_position():
	return Vector2(0, slot * size_y + slot * gap)

func _ready():
	position = calc_position()
	
	if res:
		fill_res()

func _process(delta):
	if order_update:
		var new_pos = calc_position()
		var direction = (new_pos - position).normalized()
		
		if abs( (new_pos - position).y ) > 3:
			position += Vector2(0, direction.y * speed * delta)
		else:
			position = new_pos
			order_update = false

	elif collide_with_area != null:
		var diff = collide_with_area.get_parent().position.y - position.y
		if diff < 0 && diff > size_y / 3 * -1:
			slot = max(0, slot - 1)
			collide_with_area.get_parent().slot += 1
			order_update = true
		elif diff > 0 && diff > size_y / 3:
			slot = slot + 1
			collide_with_area.get_parent().slot -= 1
			order_update = true

func _on_EditTrigger_dbclick():
	emit_signal("edit_open", res.code)

func _on_OrderTrigger_drag(relative):
	self.position.y += relative.y

func _on_OrderTrigger_drag_start():
	drag = true

func _on_OrderTrigger_drag_end():
	drag = false
	order_update = true
	emit_signal("update_order")

func _on_OrderTrigger_area_entered(area):
	if drag == false:
		collide_with_area = area;

func _on_OrderTrigger_area_exited(area):
	if collide_with_area == area:
		collide_with_area = null

func _on_Link_pressed():
	emit_signal("link", res.code)
	link.hide()
	create.show()

func _on_Create_pressed():
	emit_signal("link_create", res.code)
	create.hide()
	link.show()
