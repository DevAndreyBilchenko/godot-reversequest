extends Node2D

export(int) var x_gap = 150
export(int) var y_gap = 150

var speech_scene = preload("res://components/dialog_editor/components/speech/scenes/speech.tscn")
var speech_res = preload("res://data/scripts/speech_res.gd")
var data
var file_name
var path_to_res
var rendered_codes = []

onready var content = $Content

func start_edit(_file_name):
	file_name = _file_name
	path_to_res = str("res://data/dialogs/", file_name, ".res")
	load_data();
	
	if len(data.speech_list) == 0:
		var root_speech = speech_res.new();
		root_speech.text = "Корневой диалог"
		data.speech_list.append(root_speech)
		save_data()
	
	render()

func load_data():
	data = ResourceLoader.load(path_to_res)
	
func save_data():
	var _err = ResourceSaver.save(path_to_res, data)

func render():
	rendered_codes = []
	for ch in content.get_children():
		ch.queue_free()
	
	render_speech(find_speech(""), 0)

func render_speech(speech, row):
	var new_speech = speech_scene.instance()
	new_speech.render(speech)
	
	var row_x = x_gap * row + new_speech.size_x * row;
	new_speech.position = Vector2(row_x, get_latest_y_by_x(row_x))
	
	row += 1
	rendered_codes.append(speech.code)
	
	for ch in speech.choice_list:
		if not is_rendered(ch.link):
			render_speech(find_speech(ch.link), row)
	
	content.add_child(new_speech)

func find_speech(code):
	for item in data.speech_list:
		if item.code == code:
			return item

func is_rendered(code):
	var result = false
	
	for item in rendered_codes:
		if item == code:
			result = true
			break
	
	return result

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
