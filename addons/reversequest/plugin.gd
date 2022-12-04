tool
extends EditorPlugin


func _enter_tree():
	add_tool_menu_item("ReverseQuest", self, "_run_reversequest_editor")


func _exit_tree():
	pass


func _run_reversequest_editor(_data):
	get_editor_interface().play_custom_scene("res://addons/reversequest/r.tscn")
