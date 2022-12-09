extends Node


var speech_renderer = preload("res://addons/reversequest/edit_dialog/speech_renderer.gd").new()
var path_to_res
var choice_res_link_zone_wait 

onready var dialog_res_controller = $DialogResController
onready var content = $Content
onready var scene_switcher_store = $SceneSwitcherStore


func _ready():
	start_edit(scene_switcher_store.send_data[0])


func start_edit(file_name):
	dialog_res_controller.load_dialog(file_name)
	speech_renderer.setup(dialog_res_controller, content)
	
	render()

	$Camera2D.current = true


func render():
	speech_renderer.render()


#func enable_link_zones():
#	for speech_res in dialog_res_controller.get_speech_list():
#		var speech_node = speech_renderer.find_speech_node(speech_res.code)
#		speech_node.enable_link_zone()
#
#
#func disable_link_zones():
#	for speech_res in dialog_res_controller.get_speech_list():
#		var speech_node = speech_renderer.find_speech_node(speech_res.code)
#		speech_node.disable_link_zone()
#
#
#func register_link_zone_waiter(choice_res):
#	choice_res_link_zone_wait = choice_res
#
#
#func clean_link_zone_waiter():
#	choice_res_link_zone_wait = null
#
#
#func get_link_zone_waiter():
#	return choice_res_link_zone_wait
#
#
#func _on_speech_remove(speech_res):
#	print("remove")
#	print(speech_res)
#	pass
#
#
#func _on_choice_add(speech_res):
#	dialog_res_controller.create_choice(speech_res.code)
#	dialog_res_controller.save()
#
#	render()
#
#
#func _on_choice_update_order(speech_code, choice_order_code):
#	dialog_res_controller.save()
#	render()
#
#
#func _on_choice_link(choice_res):
#	enable_link_zones()
#	register_link_zone_waiter(choice_res)
#
#
#func _on_choice_link_create(speech_res, choice_res):
#	disable_link_zones()
#	clean_link_zone_waiter()
#
#	var new_speech = dialog_res_controller.create_speech()
#	choice_res.link = new_speech.code
#
#	dialog_res_controller.save()
#	render()
#
#
#func _on_speech_linked(speech_res):
#	disable_link_zones()
#
#	var choice_res_waiter = get_link_zone_waiter()
#	choice_res_waiter.link = speech_res.code
#
#	dialog_res_controller.save()
#	render()
#
#
#func _on_speech_renderer_instance_speech(new_speech):
#	new_speech.connect("speech_edit", self, "_on_speech_edit")
#	new_speech.connect("speech_remove", self, "_on_speech_remove")
#	new_speech.connect("choice_add", self, "_on_choice_add")
#	new_speech.connect("choice_edit", self, "_on_choice_edit")
#	new_speech.connect("choice_update_order", self, "_on_choice_update_order")
#	new_speech.connect("choice_link", self, "_on_choice_link")
#	new_speech.connect("choice_link_create", self, "_on_choice_link_create")
#	new_speech.connect("linked", self, "_on_speech_linked")
