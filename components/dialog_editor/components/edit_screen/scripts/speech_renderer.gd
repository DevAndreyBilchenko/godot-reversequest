extends Reference


signal _iterate_item
signal _cycle_done
signal instance_speech(node)

var speech_scene = preload("res://components/dialog_editor/components/speech/scenes/speech.tscn")
var roadline_scene = preload("res://components/dialog_editor/components/roadline/scenes/roadline.tscn")
var grid_stats_class = preload("res://components/dialog_editor/components/edit_screen/scripts/grid_stats.gd")

var grid_stats = grid_stats_class.new()
var check_list = []

var dialog
var container

var counter = 0

func _init():
	var _err = connect("_iterate_item", self, "_on_iterate_item")
	_err = connect("_cycle_done", self, "_on_cycle_done")


func setup(_dialog, _container):
	dialog = _dialog
	container = _container


func render():
	counter = 0
	grid_stats.reset()
	render_speech(dialog.find_root_speech(), 0)


func render_speech(speech, depth):
	if not is_speech_rendered(speech.code):
		var new_speech = speech_scene.instance()

		new_speech.render(speech)
		new_speech.name = get_speech_node_name(speech.code)
		
		container.add_child(new_speech)
		
		emit_signal("instance_speech", new_speech)

	grid_stats.register_element(depth, speech.code)

	depth += 1
	for choice in speech.choice_list:
		if choice.has_link():
			grid_stats.register_roadline_deffered(choice.code, speech.code, choice.link)
				
	for choice in speech.choice_list:
		if choice.has_link():
			if not is_speech_rendered(choice.link):
				render_speech(dialog.find_speech(choice.link), depth)
			if not find_roadline_node(choice.code, speech.code, choice.link):
				render_roadline(choice.code, speech.code, choice.link)
				
	emit_signal("_iterate_item")


func is_speech_rendered(code):
	return find_speech_node(code) != null


func find_speech_node(code):
	return container.get_node_or_null(get_speech_node_name(code))


func find_roadline_node(choice_code, from_node, to_node):
	return container.get_node_or_null(get_roadline_node_name(choice_code, from_node, to_node))


func get_speech_node_name(speech_code):
	return str("Speech_code_", speech_code)


func get_roadline_node_name(choice_code, from_node, to_node):
	return str("Roadline_choice_", choice_code, "_from_", from_node, "_to_", to_node)


func render_roadline(choice_code, from_node, to_node):
	var new_roadline = roadline_scene.instance()
	new_roadline.name = get_roadline_node_name(choice_code, from_node, to_node)
	container.add_child(new_roadline)


func update_positions():
	for speech in dialog.speech_list:
		var speech_node = find_speech_node(speech.code)
		
		speech_node.position = calc_speech_position(speech.code)

		for choice in speech.choice_list:
			if choice.has_link():
				var roadline_node = find_roadline_node(choice.code, speech.code, choice.link)
				var choice_rect = (speech_node.get_choice_node_rect(choice.code) as Rect2)
				var navpath = grid_stats.get_roadline_navpath(choice.code, speech.code)
				
				var wp = roadline_node.create_waypoint(
					choice_rect.position + Vector2(choice_rect.size.x, choice_rect.size.y / 2),
					navpath[0],
					get_summary_row_height(navpath[1], true),
					navpath[2],
					navpath[3],
					calc_speech_position(choice.link) + Vector2(0, 15)
				)
				
				roadline_node.draw(wp)


func calc_speech_position(speech_code):
	var grid_pos = grid_stats.get_element_position(speech_code)
	var speech_node = find_speech_node(speech_code)
	
	return Vector2(
			(grid_pos.x * (speech_node.size_x + 45)) + (grid_stats.get_summary_roadlines_left_col(grid_pos.x) * 20),
			get_summary_row_height(grid_pos.y)
		)

func get_summary_row_height(row_index, ingnore_last_roadlines = false):
	var roadlines = 0
	
	if not ingnore_last_roadlines:
		roadlines = grid_stats.get_summary_roadlines_upper_row(row_index)
	else: 
		roadlines = grid_stats.get_summary_roadlines_upper_row(row_index - 1)
	
	var rows_h = 0
	
	for index in row_index:
		var row_items = grid_stats.get_row_items(index)
		var more_choice = {
			"code": -1,
			"choice_count": -1
		}
	
		for code in row_items:
			var speech = dialog.find_speech(code)
			if more_choice.choice_count < speech.choice_list.size():
				more_choice.code = speech.code
				more_choice.choice_count = speech.choice_list.size()
				
		var biggest_speech_in_row = find_speech_node(more_choice.code)
		rows_h += biggest_speech_in_row.size_y
		
	return rows_h + roadlines * 20


func _on_cycle_done():
	update_positions()


func _on_iterate_item():
	counter += 1
	
	if counter >= dialog.get_speech_count():
		emit_signal("_cycle_done")
