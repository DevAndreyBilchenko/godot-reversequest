extends Control

var DialogResController = preload("res://addons/reversequest/gd_scripts/dialog_res_controller.gd")
var EditorResController = preload("res://addons/reversequest/gd_scripts/editor_res_controller.gd")
var choose_item_scene = preload("res://addons/reversequest/components/dialog_editor/components/choose_page/scenes/choose_item.tscn")

onready var choose_page = $ChoosePage

var dialog_res_controller = DialogResController.new()
var editor_res_controller = EditorResController.new()

func _ready():
	var dialog_file_names = dialog_res_controller.get_saved_dialogs()
	
	for dialog_fname in dialog_file_names:
		var item_node = choose_item_scene.instance()
		var meta = editor_res_controller.get_dialog_item(dialog_fname)
		var raw_name = dialog_fname.replace(".res", "")
		var title = raw_name
		var alt_text = ""
		
		if meta:
			pass
		
		item_node.connect("remove", self, "_on_dialog_item_remove")
		item_node.connect("apply", self, "_on_dialog_item_apply")
		
		choose_page.add_item(item_node)
		item_node.call_deferred("setup", dialog_fname, title, alt_text)


func _on_dialog_item_remove(ref, id):
	choose_page.remove_item(ref)
	dialog_res_controller.remove_saved_dialog(id)
	editor_res_controller.remove_dialog_item(id)


func _on_dialog_item_apply(ref, id):
	pass
