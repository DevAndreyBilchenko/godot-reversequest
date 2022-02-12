extends Node2D

func _ready():
	#clean()
	add_create_first_button();

func add_create_first_button():
	var create_first_btn = preload("res://components/dialog_editor/components/create_first_button/scenes/create_first_button.tscn")
	add_child(create_first_btn.instance())

func clean():
	for _i in self.get_children():
		_i.queue_free()
