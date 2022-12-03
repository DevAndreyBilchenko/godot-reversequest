extends Control

signal display_type_updated
signal errors_updated


const DISPLAY_TYPE_CREATE = "create"
const DISPLAY_TYPE_EDIT = "edit"

var DialogResController = preload("res://addons/reversequest/gd_scripts/dialog_res_controller.gd")
var EditorResController = preload("res://addons/reversequest/gd_scripts/editor_res_controller.gd")

var dialog_res_controller = DialogResController.new()
var editor_res_controller = EditorResController.new()

onready var scene_switcher_store = $SceneSwitcherStore
onready var scene_switcher_actor = $LayoutStandard/VBoxContainer/MarginContainer/VBoxContainer/MarginContainer3/HBoxContainer2/EditorButton/SceneSwitcherActor
onready var editor_name_line_edit = $LayoutStandard/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/MarginContainer/EditorNameLineEdit

var dialog_res
var dialog_meta_res
var display_type = DISPLAY_TYPE_CREATE
var rename = false
var errors = {
	"duplicate_filename": false,
	"empty_filename": false
}
var any_error = false setget , _get_any_error

func _ready():
	var sd = scene_switcher_store.send_data
	
	if sd.size() == 0:
		_update_display_type(DISPLAY_TYPE_CREATE)
		dialog_res = dialog_res_controller.create_dialog("")
		dialog_meta_res = editor_res_controller.add_dialog_item("", "")
		errors.empty_filename = true
	else:
		scene_switcher_actor.send_data = scene_switcher_store.send_data
		var dialog_file_name = scene_switcher_store.send_data[0]
		dialog_res = dialog_res_controller.load_dialog(dialog_file_name)
		dialog_meta_res = editor_res_controller.get_dialog_item(dialog_file_name)
		
		if dialog_meta_res == null: 
			dialog_meta_res = editor_res_controller.add_dialog_item("", dialog_file_name)
			pass
			
		_update_display_type(DISPLAY_TYPE_EDIT)


func _update_error(err_name, val):
	if errors[err_name] != val:
		errors[err_name] = val
		emit_signal("errors_updated")


func _update_display_type(type):
	if display_type != type:
		display_type = type
		emit_signal("display_type_updated")


func _on_create_button_pressed():
	editor_res_controller.save()
	dialog_res_controller.save(dialog_meta_res.file_name)
	scene_switcher_actor.send_data = dialog_meta_res.file_name
	_update_display_type(DISPLAY_TYPE_EDIT)


func _on_update_button_pressed():
	if rename:
		dialog_res_controller.rename_saved_dialog(dialog_meta_res.file_name)
		rename = false
		
	dialog_res_controller.save()
	editor_res_controller.save()


func _on_file_name_prop_changed(new_val, old_val):
	if new_val == old_val:
		return
	
	if new_val == "":
		_update_error("empty_filename", true)
		return
	
	
	if dialog_res_controller.exists_saved_dialog(new_val):
		_update_error("duplicate_filename", true)
		return
	
	_update_error("empty_filename", false)
	_update_error("duplicate_filename", false)
	
	rename = true


func _get_any_error():
	var err = false
	
	for val in errors.values():
		if val:
			err = true
			break
	
	return err
