extends Reference


signal _iterate_item
signal instance_speech(node)


var speech_scene = preload("res://addons/reversequest/speech/speech.tscn")
var roadline_scene = preload("res://addons/reversequest/roadline/roadline.tscn")
var GridStats = preload("res://addons/reversequest/edit_dialog/grid_stats.gd")

var grid_stats = GridStats.new()
var check_list = []

var _dialog_res_controller
var _container


func _init():
	var _err = connect("_iterate_item", self, "_on_iterate_item")


func setup(dialog_res_controller, container):
	_dialog_res_controller = dialog_res_controller
	_container = container


func render():
	var speech_count = _dialog_res_controller.get_speech_list().size()
	var iterator = 0
	
	var await_list = Array()
	await_list.resize(speech_count)
	await_list[iterator] = _dialog_res_controller.get_speech(0)
	
	grid_stats.reset()
	grid_stats.prepare_size(speech_count)
	grid_stats.register_item(0, -1)
	
	for speech_res in await_list:
		render_speech(speech_res)

		for choice in speech_res.choice_list:
			if choice.has_link() and not grid_stats.has_item(choice.link):
				iterator += 1
				await_list[iterator] = _dialog_res_controller.get_speech(choice.link)
				grid_stats.register_item(choice.link, speech_res.code)
				grid_stats.register_connection(speech_res.code, choice.code, choice.link)
		
		var grid_item = grid_stats.get_item(speech_res.code)
		grid_stats.register_choice_count(grid_item.depth, speech_res.choice_list.size())


func render_speech(speech):
	if not is_speech_rendered(speech.code):
		var new_speech = speech_scene.instance()

		new_speech.setup(speech, _dialog_res_controller)
		new_speech.name = get_speech_node_name(speech.code)
		
		_container.add_child(new_speech)
		
		emit_signal("instance_speech", new_speech)


func is_speech_rendered(code):
	return find_speech_node(code) != null


func find_speech_node(code):
	return _container.get_node_or_null(get_speech_node_name(code))


func find_roadline_node(choice_code, from_node, to_node):
	return _container.get_node_or_null(get_roadline_node_name(choice_code, from_node, to_node))


func get_speech_node_name(speech_code):
	return str("Speech_code_", speech_code)


func get_roadline_node_name(choice_code, from_node, to_node):
	return str("Roadline_choice_", choice_code, "_from_", from_node, "_to_", to_node)


func render_roadline(choice_code, from_node, to_node):
	var new_roadline = roadline_scene.instance()
	new_roadline.name = get_roadline_node_name(choice_code, from_node, to_node)
	_container.add_child(new_roadline)


func update_positions():
	for speech in _dialog_res_controller.speech_list:
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
	var grid_item = grid_stats.get_item(speech_code)
	
	return Vector2(
		get_summary_col_width(grid_item.depth),
		get_summary_row_height(grid_item.col_index)
	)

func get_summary_col_width(col_index):
	#(grid_item.depth * (speech_node.size_x + 45)) + (grid_stats.get_summary_roadlines_left_col(grid_pos.x) * 20),
	pass


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
			var speech = _dialog_res_controller.find_speech(code)
			if more_choice.choice_count < speech.choice_list.size():
				more_choice.code = speech.code
				more_choice.choice_count = speech.choice_list.size()
				
		var biggest_speech_in_row = find_speech_node(more_choice.code)
		rows_h += biggest_speech_in_row.size_y
		
	return rows_h + roadlines * 20

