extends Node2D

signal edit_start(file_name)

var editor_res_controller = preload("res://addons/reversequest/gd_scripts/editor_res_controller.gd").new()
var dialog_res_controller = preload("res://addons/reversequest/gd_scripts/dialog_res_controller.gd").new()

func _on_New_pressed():
	$ScreenContainer/CenterContainer.hide()
	$ScreenContainer/EnterName.show()

func _on_Open_pressed():
	$ScreenContainer/CenterContainer.hide()
	
	var card_scene = preload("res://addons/reversequest/components/dialog_editor/components/card/scenes/card.tscn")
	var container = $ScreenContainer/ScrollContainer/DialogsList
	
	for n in container.get_children():
		n.queue_free()
	
	for item in editor_res_controller.get_dialog_list():
		var card_item = card_scene.instance()
		card_item.set_data(item.display_name, item.file_name)
		card_item.connect("open", self, "_on_Card_open")
		container.add_child(card_item)
	
	$ScreenContainer/ScrollContainer.show()

func _on_CreateButton_pressed():
	var editor_name = $ScreenContainer/EnterName/EditorNameLineEdit.text
	var file_name = $ScreenContainer/EnterName/NameLineEdit.text
	
	editor_res_controller.add_dialog_item(editor_name, file_name)
	dialog_res_controller.create_dialog(file_name)
	
	emit_signal("edit_start", file_name)

func _on_Card_open(id):
	emit_signal("edit_start", id)
