extends Node2D


var speech_renderer_class = preload("res://addons/reversequest/components/dialog_editor/components/edit_screen/scripts/speech_renderer.gd")
var dialog_res_controller = preload("res://addons/reversequest/gd_scripts/dialog_res_controller.gd")

var path_to_res
var wait_link_zone 

var speech_renderer = speech_renderer_class.new()

onready var content = $Content
onready var edit_speech_hud = $EditSpeech
onready var edit_choice_hud = $EditChoice

func start_edit(file_name):
	dialog_res_controller.load_dialog(file_name)
	speech_renderer.setup(dialog_res_controller, content)
	
	render()

	$Camera2D.current = true


func render():
	speech_renderer.render()


func get_list_item_index(code, list):
	var index = 0
	for item in list:
		if item.code == code:
			return index
		index += 1


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


func _on_speech_edit(speech_code):
	var speech = dialog_res_controller.get_speech(speech_code)
	if speech != null:
		edit_speech_hud.open(speech)


func _on_speech_remove(speech_code):
	print("remove")
	print(speech_code)
	pass


func _on_choice_add(speech_code):
	dialog_res_controller.create_choice(speech_code)
	dialog_res_controller.save()
	
	render()


func _on_EditSpeech_apply(speech):
	dialog_res_controller.save()
	edit_speech_hud.close()


func _on_EditSpeech_cancel():
	edit_speech_hud.close()


func _on_EditChoice_apply(_speech_code, _choice_res):
	dialog_res_controller.save()
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


func _on_speech_renderer_instance_speech(new_speech):
	new_speech.connect("speech_edit", self, "_on_speech_edit")
	new_speech.connect("speech_remove", self, "_on_speech_remove")
	new_speech.connect("choice_add", self, "_on_choice_add")
	new_speech.connect("choice_edit", self, "_on_choice_edit")
	new_speech.connect("choice_update_order", self, "_on_choice_update_order")
	new_speech.connect("choice_link", self, "_on_choice_link")
	new_speech.connect("choice_link_create", self, "_on_choice_link_create")
	new_speech.connect("linked", self, "_on_speech_linked")
