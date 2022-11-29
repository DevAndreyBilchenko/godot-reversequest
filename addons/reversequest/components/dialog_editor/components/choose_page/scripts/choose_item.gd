extends Control

signal remove(ref, id)
signal apply(ref, id)

onready var title_node = $MarginContainer/VBoxContainer2/VBoxContainer/Label
onready var alt_text_node = $MarginContainer/VBoxContainer2/VBoxContainer/LabelOther
onready var button_apply = $MarginContainer/VBoxContainer2/MarginContainer/HBoxContainer/Button2
onready var button_remove = $MarginContainer/VBoxContainer2/MarginContainer/HBoxContainer/Button
onready var confirm_dialog = $ConfirmationDialog

var id


func _ready():
	button_apply.connect("pressed", self, "_on_button_apply_click")
	button_remove.connect("pressed", self, "_on_button_remove_click")
	confirm_dialog.connect("confirmed", self, "_on_remove_confirmed")
	confirm_dialog.get_cancel().text = "Отмена"
	confirm_dialog.get_ok().text = "Да"


func setup(_id, title = "", alt_text = ""):
	title_node.text = title
	alt_text_node.text = alt_text
	id = _id


func _on_button_apply_click():
	emit_signal("apply", self, id)


func _on_button_remove_click():
	confirm_dialog.popup()


func _on_remove_confirmed():
	emit_signal("remove", self, id)
