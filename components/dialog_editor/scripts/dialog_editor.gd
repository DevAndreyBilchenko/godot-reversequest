extends Node2D

onready var start_screen = $StartScreen
onready var edit_screen = $EditScreen

func _on_StartScreen_edit_start(file_name):
	start_screen.hide();
	edit_screen.show();
	edit_screen.start_edit(file_name);
