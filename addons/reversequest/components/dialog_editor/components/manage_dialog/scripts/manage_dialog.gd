extends Control

var DialogResController = preload("res://addons/reversequest/gd_scripts/dialog_res_controller.gd")
var EditorResController = preload("res://addons/reversequest/gd_scripts/editor_res_controller.gd")

var dialog_res_controller = DialogResController.new()
var editor_res_controller = EditorResController.new()

onready var scene_switcher_store = $SceneSwitcherStore

var dialog_res
var dialog_meta_res

func _ready():
	var dialog_file_name = scene_switcher_store.send_data[0]
	dialog_res = dialog_res_controller.load_dialog(dialog_file_name)
	dialog_meta_res = editor_res_controller.get_dialog_item(dialog_file_name)

func update_fields():
	
	pass
