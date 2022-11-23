extends Node2D

export(int) var x_gap = 250
export(int) var y_gap = 150

var speech_scene = preload("res://components/dialog_editor/components/speech/scenes/speech.tscn")
var roadline_scene = preload("res://components/dialog_editor/components/roadline/scenes/roadline.tscn")
var speech_res_class = preload("res://data/scripts/speech_res.gd")
var choice_res_class = preload("res://data/scripts/choice_res.gd")
var grid_class = preload("res://components/dialog_editor/components/edit_screen/scripts/grid.gd")
var dialog
var file_name
var path_to_res
var rendered_codes = []
var wait_link_zone
var grid = grid_class.new()

onready var content = $Content
onready var road = $Road
onready var edit_speech_hud = $EditSpeech
onready var edit_choice_hud = $EditChoice

func start_edit(_file_name):
	file_name = _file_name
	path_to_res = str("res://data/dialogs/", file_name, ".res")
	load_dialog()

	if len(dialog.speech_list) == 0:
		create_root_speech()
		save_dialog()

	render()

	$Camera2D.current = true


func load_dialog():
	dialog = ResourceLoader.load(path_to_res)


func save_dialog():
	var _err = ResourceSaver.save(path_to_res, dialog, ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)


func render():
	grid.update(dialog)
	render_speech(dialog.find_root_speech())


func render_speech(speech):
	var speech_node
	
	if not is_rendered(speech.code):
		var new_speech = speech_scene.instance()

		new_speech.connect("speech_edit", self, "_on_speech_edit")
		new_speech.connect("speech_remove", self, "_on_speech_remove")
		new_speech.connect("choice_add", self, "_on_choice_add")
		new_speech.connect("choice_edit", self, "_on_choice_edit")
		new_speech.connect("choice_update_order", self, "_on_choice_update_order")
		new_speech.connect("choice_link", self, "_on_choice_link")
		new_speech.connect("choice_link_create", self, "_on_choice_link_create")
		new_speech.connect("linked", self, "_on_speech_linked")

		new_speech.render(speech)
		new_speech.name = get_speech_node_name(speech.code)
		
		content.add_child(new_speech)
		rendered_codes.append(speech.code)
		
		speech_node = new_speech
	else:
		speech_node = find_speech_node(speech.code)


	for ch in speech.choice_list:
		if has_link(ch):
			if not is_rendered(ch.link):
				render_speech(dialog.find_speech(ch.link))
				render_roadline(speech_node.find_choice_node(ch.code), find_speech_node(ch.link))


func find_speech_node(code):
	return content.get_node_or_null(get_speech_node_name(code))


func get_speech_nodes():
	return content.get_children()


func get_list_item_index(code, list):
	var index = 0
	for item in list:
		if item.code == code:
			return index
		index += 1


func is_rendered(code):
	var result = false

	for item in rendered_codes:
		if item == code:
			result = true
			break

	return result


func has_link(target):
	return target.link != -1


func get_latest_y_by_x(x):
	var max_bottom = 0

	for ch in content.get_children():
		if ch.position.x == x:
			var bottom = ch.position.y + ch.size_y;
			if bottom > max_bottom:
				max_bottom = bottom

	if max_bottom != 0:
		max_bottom += y_gap

	return max_bottom


func create_root_speech():
	var root_speech = speech_res_class.new()
	root_speech.code = 0
	root_speech.text = "Корневая реплика"
	root_speech.choice_list = []
	dialog.speech_list.append(root_speech)


func create_speech():
	var speech = speech_res_class.new()
	speech.code = get_next_code_index(dialog.speech_list)
	speech.text = "Новая реплика"
	speech.choice_list = []
	return speech


func get_next_code_index(list):
	var code = -1

	if list != null:
		for item in list:
			if item.code > code:
				code = item.code

	return code + 1


func enable_link_zones():
	for speech in content.get_children():
		speech.enable_link_zone()


func disable_link_zones():
	for speech in content.get_children():
		speech.disable_link_zone()


func register_link_zone_waiter(speech_code, choice_code):
	wait_link_zone = {
		"speech": speech_code,
		"choice": choice_code
	}


func clean_link_zone_waiter():
	wait_link_zone = null


func get_link_zone_waiter():
	return wait_link_zone


func render_roadline(from_node, to_node):
	var new_roadline = roadline_scene.instance()
	road.add_child(new_roadline)
	new_roadline.setup(x_gap, y_gap, to_node.size_x)
	new_roadline.draw(from_node, to_node, get_speech_nodes())


func get_speech_node_name(speech_code):
	return str("Speech_code_", speech_code)


func _on_speech_edit(speech_code):
	var speech = dialog.find_speech(speech_code)
	if speech != null:
		edit_speech_hud.open(speech)


func _on_speech_remove(speech_code):
	print("remove")
	print(speech_code)
	pass


func _on_choice_add(speech_code):
	var index = get_list_item_index(speech_code, dialog.speech_list)
	var choice = choice_res_class.new()
	choice.code = get_next_code_index(dialog.speech_list[index].choice_list)
	choice.text = "Новая реплика"

	if dialog.speech_list[index].choice_list == null:
		dialog.speech_list[index].choice_list = []

	dialog.speech_list[index].choice_list.append(choice)

	save_dialog()
	render()


func _on_EditSpeech_apply(speech):
	var index = get_list_item_index(speech.code, dialog.speech_list)

	if index != null:
		dialog.speech_list[index] = speech
		save_dialog()
		render()

	edit_speech_hud.close()


func _on_EditSpeech_cancel():
	edit_speech_hud.close()


func _on_EditChoice_apply(speech_code, choice_res):
	var speech_index = get_list_item_index(speech_code, dialog.speech_list)

	if speech_index == null:
		return

	var choice_index = get_list_item_index(choice_res.code, dialog.speech_list[speech_index].choice_list)

	if choice_index == null:
		return

	dialog.speech_list[speech_index].choice_list[choice_index] = choice_res
	save_dialog()
	render()
	edit_choice_hud.close()

func _on_EditChoice_cancel():
	edit_choice_hud.close()


func _on_choice_edit(speech_code, choice_code):
	var speech_index = get_list_item_index(speech_code, dialog.speech_list)

	if speech_index == null:
		return

	var choice_index = get_list_item_index(choice_code, dialog.speech_list[speech_index].choice_list)

	if choice_index == null:
		return

	edit_choice_hud.open(speech_code, dialog.speech_list[speech_index].choice_list[choice_index])


func _on_choice_update_order(speech_code, choice_order_code):
	var speech_index = get_list_item_index(speech_code, dialog.speech_list)

	if speech_index == null:
		return

	var ordered = []

	for code in choice_order_code:
		for ch_item in dialog.speech_list[speech_index].choice_list:
			if ch_item.code == code:
				ordered.append(ch_item)
				break

	dialog.speech_list[speech_index].choice_list = ordered
	save_dialog()
	render()


func _on_choice_link(speech_code, choice_code):
	enable_link_zones()
	register_link_zone_waiter(speech_code, choice_code)


func _on_choice_link_create(speech_code, choice_code):
	disable_link_zones()
	clean_link_zone_waiter()

	var speech_index = get_list_item_index(speech_code, dialog.speech_list)

	if speech_index == null:
		return

	var choice_index = get_list_item_index(choice_code, dialog.speech_list[speech_index].choice_list)

	if choice_index == null:
		return

	var new_speech = create_speech()
	dialog.speech_list.append(new_speech)
	dialog.speech_list[speech_index].choice_list[choice_index].link = new_speech.code

	save_dialog()
	render()


func _on_speech_linked(speech_code):
	disable_link_zones()

	var waiter = get_link_zone_waiter()
	var speech_index = get_list_item_index(waiter.speech, dialog.speech_list)

	if speech_index == null:
		return

	var choice_index = get_list_item_index(waiter.choice, dialog.speech_list[speech_index].choice_list)

	if choice_index == null:
		return

	dialog.speech_list[speech_index].choice_list[choice_index].link = speech_code

	save_dialog()
	render()
