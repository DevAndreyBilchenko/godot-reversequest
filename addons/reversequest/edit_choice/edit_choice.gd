extends Control

var res
var _changed_emitted = false

onready var store = $SceneSwitcherStore
onready var apply = $MarginContainer/HBoxContainer/HBoxContainer/VBoxContainer/Control/VBoxContainer/Apply


func _ready():
	res = store.send_data[0]


func _on_bind_input_on_prop_prop_changed(new_val, old_val):
	if new_val != old_val && not _changed_emitted:
		res.emit_changed()
		_changed_emitted = true
