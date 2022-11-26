extends Node2D

signal speech_edit(speech_code)
signal speech_remove(speech_code)
signal choice_add(speech_code)
signal choice_edit(choice_res)
signal choice_update_order(speech_code, choice_order_code)
signal choice_link(speech_code, choice_code)
signal choice_link_create(speech_code, choice_code)
signal linked(speech_code)

export(int) var size_x
var size_y setget ,size_y_get
var base_y = 308
var bottom = 0
var code = -1


func render(speech_res):
	code = speech_res.code
	set_text(speech_res.text)
	for ch in speech_res.choice_list:
		add_choice(ch)


func set_text(text):
	$Control/Text.text = text
	$Debug/Code.text = str(code)


func enable_link_zone():
	$LinkZone.show()


func disable_link_zone():
	$LinkZone.hide()


func add_choice(choice_res):
	var choice = preload("res://addons/reversequest/components/dialog_editor/components/choice/scenes/choice.tscn")
	var choice_container = get_node("ChoiceContainer")
	var new_instance = choice.instance()
	
	new_instance.slot = choice_container.get_child_count()
	new_instance.connect("edit_open", self, "_on_choice_edit_open")
	new_instance.connect("update_order", self, "_on_choice_update_order")
	new_instance.connect("link", self, "_on_choice_link")
	new_instance.connect("link_create", self, "_on_choice_link_create")

	choice_container.add_child(new_instance)
	
	if (choice_res != null):
		new_instance.set_res(choice_res)

	new_instance.name = get_choice_node_name(new_instance.code)
	
	update_choice_line()


func update_choice_line():
	var choice_container = get_node("ChoiceContainer")
	var choice_line = get_node("ChoiceLine")
	var choice_add = get_node("ChoiceAdd")
	var index = choice_container.get_child_count()
	var base_x = choice_line.get_point_position(0).x
	
	if index == 0:
		choice_line.set_point_position(1, Vector2(base_x, base_y + 20))
		choice_add.rect_position = Vector2(2, base_y + 26)
		bottom = base_y + 26
	else:
		var item_y = choice_container.get_child(index-1).position.y + choice_container.position.y
		choice_line.set_point_position(1, Vector2(base_x, item_y + 45))
		choice_add.rect_position = Vector2(2, item_y + 51)
		bottom = item_y + 51


func size_y_get():
	return bottom + 50


func find_choice_node(choice_code):
	return get_node_or_null(str("ChoiceContainer/", get_choice_node_name(choice_code)))


func get_choice_node_rect(choice_code):
	var choice = find_choice_node(choice_code)
	return Rect2(choice.global_position, Vector2(choice.size_x, choice.size_y))


func _ready():
	update_choice_line()


func _on_ChoiceAdd_pressed():
	emit_signal("choice_add", code)


func _on_Edit_pressed():
	emit_signal("speech_edit", code)


func _on_Remove_pressed():
	emit_signal("speech_remove", code)
	

func _on_choice_edit_open(choice_res):
	emit_signal("choice_edit", choice_res)


func _on_choice_update_order():
	var choice_container = get_node("ChoiceContainer")
	var code_list = [];
	code_list.resize(choice_container.get_child_count())

	for item in choice_container.get_children():
		code_list[item.slot] = item.code
	
	emit_signal("choice_update_order", code, code_list)


func _on_choice_link(choice_code):
	emit_signal("choice_link", code, choice_code)


func _on_choice_link_create(choice_code):
	emit_signal("choice_link_create", code, choice_code)

func _on_LinkZone_pressed():
	emit_signal("linked", code)


func get_choice_node_name(_code):
	return str("Coice_code_", _code)
