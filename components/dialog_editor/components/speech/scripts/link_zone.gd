extends Node2D

signal pressed

func _on_LinkArea2D_click():
	self.hide()
	emit_signal("pressed")
