extends Node

export(String, MULTILINE) var tooltip_text

var _entered = false
var tooltip


func _ready():
	var button = get_parent()
	button.connect("mouse_entered", self, "_on_mouse_entered")
	button.connect("mouse_exited", self, "_on_mouse_exited")


func _show_tooltip():
	var button = get_parent()
	
	if not tooltip:
		tooltip = PopupPanel.new()
		var label = Label.new()
		label.text = tooltip_text
		
	if not tooltip.is_inside_tree():
		button.add_child(tooltip)


func _on_mouse_entered():
	yield(get_tree().create_timer(0.25), "timeout")
	
	if _entered:
		_show_tooltip()
		

func _on_mouse_exited():
	_entered = false
