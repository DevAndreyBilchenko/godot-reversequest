extends Control

var DialogResController = preload("res://addons/reversequest/gd_scripts/dialog_res_controller.gd")
var EditorResController = preload("res://addons/reversequest/gd_scripts/editor_res_controller.gd")
var choose_item_scene = preload("res://addons/reversequest/components/dialog_editor/components/choose_page/scenes/choose_item.tscn")

var dialog_res_controller = DialogResController.new()
var editor_res_controller = EditorResController.new()

func _ready():
	var dialog_file_names = dialog_res_controller.get_saved_dialogs()
	var dialog_meta = editor_res_controller.get_dialog_list()
	pass
