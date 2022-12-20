extends Reference


signal _iterate_item
signal instance_speech(node)

const CONNECTION_SIZE = 15
const ROADLINE_SIZE = 20
const COLUMN_GAP = 30
const ROW_GAP = 20

var speech_scene = preload("res://addons/reversequest/speech/speech.tscn")
var roadline_scene = preload("res://addons/reversequest/roadline/roadline.tscn")
var GridStats = preload("res://addons/reversequest/edit_dialog/grid_stats.gd")
var GridStatsRoadmapItem = preload("res://addons/reversequest/edit_dialog/grid_stats_roadmap_item.gd")

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
		var grid_item = grid_stats.get_item(speech_res.code)
		var speech_node = render_speech(speech_res)
		
		var ordered_choices = _dialog_res_controller.get_ordered_choice_list(speech_res.code)
		if ordered_choices.size() != 0:
			var clean_choices = []
			
			for ch in ordered_choices:
				if ch.has_link():
					clean_choices.append(ch)
			
			var col = grid_stats.get_col(grid_item.depth)
			col.add_empty_out(clean_choices.size())
			
			for choice_idx in clean_choices.size():
				var choice = clean_choices[choice_idx]
				if not grid_stats.has_item(choice.link):
					iterator += 1
					await_list[iterator] = _dialog_res_controller.get_speech(choice.link)
					grid_stats.register_item(choice.link, speech_res.code)
				grid_stats.register_connection(speech_res.code, choice.code, choice_idx, choice.link)
				if not find_roadline_node(choice.code, speech_res.code, choice.link):
					render_roadline(choice.code, speech_res.code, choice.link)
					
		grid_stats.register_choice_count(grid_item.depth, speech_res.choice_list.size())
		grid_stats.register_max_real_height_in_row(grid_item.col_index, speech_node.size_y)
		grid_stats.register_max_real_width_in_col(grid_item.depth, speech_node.size_x)
		
	update_positions()


func render_speech(speech):
	var new_speech = find_speech_node(speech.code)
	
	if not new_speech:
		new_speech = speech_scene.instance()

		new_speech.setup(speech, _dialog_res_controller)
		new_speech.name = get_speech_node_name(speech.code)
		
		_container.add_child(new_speech)
		
		emit_signal("instance_speech", new_speech)
		
	return new_speech


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
	for speech in _dialog_res_controller.get_speech_list():
		var speech_node = find_speech_node(speech.code)
		
		speech_node.rect_position = calc_speech_position(speech.code)

		for choice in speech.choice_list:
			if choice.has_link():
				var roadline_node = find_roadline_node(choice.code, speech.code, choice.link)
				var choice_node = speech_node.find_choice_node(choice.code)
				var to_item = grid_stats.get_item(choice.link)
				var to_node = find_speech_node(choice.link)
				var roadmap = to_item.get_connection_roadmap(speech.code, choice.code)
				
				roadline_node.draw(_convert_roadmap(roadmap, choice_node, to_node))


func calc_speech_position(speech_code):
	var grid_item = grid_stats.get_item(speech_code)
	
	return Vector2(
		get_summary_col_width(grid_item.depth - 1) + grid_stats.get_in_roadlines_in_col(grid_item.depth) * ROADLINE_SIZE + CONNECTION_SIZE,
		get_summary_row_height(grid_item.col_index - 1)
	)


func get_summary_col_width(col_index):
	if col_index < 0:
		return 0
	
	var width = 0
	
	for index in col_index+1:
		width += grid_stats.get_col_max_real_width(index) + (CONNECTION_SIZE * 2) + grid_stats.get_summary_roadlines_in_col(index) * ROADLINE_SIZE + COLUMN_GAP

	return width



func get_summary_row_height(row_index):
	if row_index < 0:
		return 0
	
	var rows_h = 0
	
	for index in row_index+1:
		rows_h += grid_stats.get_row_max_real_height(index) + grid_stats.get_summary_roadlines_in_row(index) * ROADLINE_SIZE + ROW_GAP
		
	return rows_h


func _convert_roadmap(roadmap, from_choice, to_item):
	var converted = []

	for step in roadmap.get_map():
		var point
	
		var col_stats = grid_stats.get_col(step.col)
		var row_stats = grid_stats.get_row(step.row) 
		
		point = Vector2(
			get_summary_col_width(step.col),
			0
		)
		
		if step.from_subitem:
			point.y = (from_choice.rect_global_position.y + from_choice.rect_size.y) - from_choice.rect_size.y / 2
		else:
			point.y = get_summary_row_height(step.row)
			
		if step.row_shift != 0:
			point.y -= (row_stats.get_roadlines_count() - step.row_shift) * ROADLINE_SIZE + ROW_GAP
		elif not step.from_subitem:
			point.y -= (row_stats.get_roadlines_count() * ROADLINE_SIZE) + (row_stats.max_real_height - 40)
		
		if step.col_shift != 0:
			if step.col_shift > 0:
				point.x -= (col_stats.get_out_roadlines_count() - step.col_shift) * ROADLINE_SIZE + COLUMN_GAP
			else:
				point.x -= (col_stats.get_out_roadlines_count() * ROADLINE_SIZE) + grid_stats.get_col_max_real_width(step.col) + CONNECTION_SIZE * 2 + abs(step.col_shift) * ROADLINE_SIZE + COLUMN_GAP
		elif not step.from_subitem:
			point.x -= col_stats.get_out_roadlines_count() * ROADLINE_SIZE + grid_stats.get_col_max_real_width(step.col) + CONNECTION_SIZE + COLUMN_GAP
		else:
			point.x -= col_stats.get_out_roadlines_count() * ROADLINE_SIZE + CONNECTION_SIZE + COLUMN_GAP
			
		
		converted.append(point)
	
	return converted
