extends Node2D


signal speech_edit(speech_res)
signal speech_remove(speech_res)
signal choice_add(speech_res)
signal choice_edit(speech_res, choice_res)
signal choice_update_order(speech_res)
signal choice_link(speech_res, choice_res)
signal choice_link_create(speech_res, choice_res)
signal linked(speech_res)


var size_x setget ,_get_size_x
var size_y setget ,_get_size_y
var base_y = 308
var bottom = 0
var res


func _ready():
	update_choice_line()


func render(speech_res):
	res = speech_res
	set_text(speech_res.text)
	for ch in speech_res.choice_list:
		add_choice(ch)


func set_text(text):
	$Control/Text.text = text
	$Debug/Code.text = str(res.code)


func enable_link_zone():
	$LinkZone.show()


func disable_link_zone():
	$LinkZone.hide()


func add_choice(choice_res):
	var choice = preload("res://addons/reversequest/choice/choice.tscn")
	var choice_container = get_node("ChoiceContainer")
	var choice_node = choice.instance()
	
	choice_node.connect("edit_open", self, "_on_choice_edit_open")
	choice_node.connect("update_order", self, "_on_choice_update_order")
	choice_node.connect("link", self, "_on_choice_link")
	choice_node.connect("link_create", self, "_on_choice_link_create")

	choice_container.add_child(choice_node)
	
	if (choice_res != null):
		choice_node.set_res(choice_res)

	choice_node.name = get_choice_node_name(choice_node.res.code)
	
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


func find_choice_node(choice_code):
	return get_node_or_null(str("ChoiceContainer/", get_choice_node_name(choice_code)))


func get_choice_node_rect(choice_code):
	var choice = find_choice_node(choice_code)
	return Rect2(choice.global_position, Vector2(choice.size_x, choice.size_y))


func get_choice_node_name(_code):
	return str("Coice_code_", _code)


func _on_ChoiceAdd_pressed():
	emit_signal("choice_add", res)


func _on_Edit_pressed():
	emit_signal("speech_edit", res)


func _on_Remove_pressed():
	emit_signal("speech_remove", res)
	

func _on_choice_edit_open(choice_res):
	emit_signal("choice_edit", res, choice_res)


func _on_choice_update_order():
	emit_signal("choice_update_order", res)


func _on_choice_link(choice_res):
	emit_signal("choice_link", res, choice_res)


func _on_choice_link_create(choice_res):
	emit_signal("choice_link_create", res, choice_res)


func _on_LinkZone_pressed():
	emit_signal("linked", res)


func _get_size_y():
	return bottom + 50


func _get_size_x():
	var sizer = $Control
	return sizer.rect_size.x
