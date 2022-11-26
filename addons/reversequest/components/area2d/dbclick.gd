extends Area2D

signal dbclick
signal click

func _ready():
	var _con = self.connect("input_event", self, "on_input_event")

func on_input_event(_viewport, ev, _shape_idx):
	if ev.is_pressed() && ev.doubleclick:
		emit_signal("dbclick")
	elif ev.is_pressed() && ev.button_mask == BUTTON_MASK_LEFT:
		emit_signal("click")
