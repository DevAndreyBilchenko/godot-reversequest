extends Control

var DialogResController = preload("res://addons/reversequest/gd_scripts/dialog_res_controller.gd")
var EditorResController = preload("res://addons/reversequest/gd_scripts/editor_res_controller.gd")
var choose_item_scene = preload("res://addons/reversequest/components/dialog_editor/components/choose_page/scenes/choose_item.tscn")
var create_item_scene = preload("res://addons/reversequest/components/dialog_editor/components/choose_page/scenes/choose_item_new.tscn")

onready var choose_page = $ChoosePage
onready var manage_actor = $SceneSwitcherActorManage

var dialog_res_controller = DialogResController.new()
var editor_res_controller = EditorResController.new()


func _ready():
	var dialog_file_names = dialog_res_controller.get_saved_dialogs()
	
	for dialog_fname in dialog_file_names:
		var item_node = choose_item_scene.instance()
		var raw_name = dialog_fname.replace(".res", "")
		var meta = editor_res_controller.get_dialog_item(raw_name)
		var title = raw_name
		var alt_text = ""
		
		if meta:
			if not meta.display_name == "":
				title = meta.display_name
			
			if meta.speech_count:
				alt_text = str("Реплики: ", meta.speech_count, " \n")

			alt_text = str(alt_text, meta.description)
			
		
		item_node.connect("remove", self, "_on_dialog_item_remove")
		item_node.connect("apply", self, "_on_dialog_item_apply")
		
		choose_page.add_item(item_node)
		item_node.call_deferred("setup", raw_name, title, alt_text)
		
	var create_item_node = create_item_scene.instance()
	
	create_item_node.connect("apply", self, "_on_dialog_item_create")
	choose_page.add_item(create_item_node)
	create_item_node.call_deferred("setup", "", "Новый диалог", "")


func _on_dialog_item_remove(ref, id):
	choose_page.remove_item(ref)
	dialog_res_controller.remove_saved_dialog(id)
	editor_res_controller.remove_dialog_item(id, true)


func _on_dialog_item_apply(ref, id):
	manage_actor.run([id])


func _on_dialog_item_create(_ref, id):
	manage_actor.run()
