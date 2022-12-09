extends Area2D

signal drag_start
signal drag(relative)
signal drag_end

var pressed = false
var last_cursor_position
var viewport


func _ready():
	viewport = get_viewport()
	var _con = self.connect("input_event", self, "on_input_event")
	

func _process(_delta):
	if pressed && Input.get_mouse_button_mask() != 0:
		var new_cursor_position = viewport.get_mouse_position()
		emit_signal("drag", new_cursor_position - last_cursor_position)
		last_cursor_position = new_cursor_position
	elif pressed:
		pressed = false
		emit_signal("drag_end")


func on_input_event(_viewport, ev, _shape_idx):
	if ev.is_class("InputEventMouseButton"):
		if pressed == false && ev.button_mask != 0:
			pressed = true
			emit_signal("drag_start")
			last_cursor_position = viewport.get_mouse_position()
