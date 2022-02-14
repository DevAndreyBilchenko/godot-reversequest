extends Node2D

func _ready():
	update_choice_line()

func set_text(text):
	$Control/Text.text = text

func add_choice(choice_data):
	var choice = preload("res://components/dialog_editor/components/choice/scenes/choice.tscn")
	var choice_container = get_node("ChoiceContainer")
	var gap = 10
	var new_instance = choice.instance()
	var index = choice_container.get_child_count()
	var pos_y = index * new_instance.size_y + index * gap
	choice_container.add_child(new_instance)
	new_instance.position = Vector2(0, pos_y)

func update_choice_line():
	var choice_container = get_node("ChoiceContainer")
	var choice_line = get_node("ChoiceLine")
	var choice_add = get_node("ChoiceAdd")
	var index = choice_container.get_child_count()
	var base_y = 308
	var base_x = choice_line.get_point_position(0).x
	
	if index == 0:
		choice_line.set_point_position(1, Vector2(base_x, base_y + 20))
		choice_add.rect_position = Vector2(2, base_y + 26)
	else:
		var item_y = choice_container.get_child(index-1).position.y + choice_container.position.y
		choice_line.set_point_position(1, Vector2(base_x, item_y + 45))
		choice_add.rect_position = Vector2(2, item_y + 51)

func _on_ChoiceAdd_pressed():
	add_choice(null)
	update_choice_line()
