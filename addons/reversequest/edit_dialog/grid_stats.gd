extends Reference

var GridStatsItem = preload("res://addons/reversequest/edit_dialog/grid_stats_item.gd")
var GridStatsSubitem = preload("res://addons/reversequest/edit_dialog/grid_stats_subitem.gd")
var GridStatsRow = preload("res://addons/reversequest/edit_dialog/grid_stats_row.gd")
var GridStatsCol = preload("res://addons/reversequest/edit_dialog/grid_stats_col.gd")
var GridStatsRoadmap = preload("res://addons/reversequest/edit_dialog/grid_stats_roadmap.gd")
var GridStatsRoadmapItem = preload("res://addons/reversequest/edit_dialog/grid_stats_roadmap_item.gd")

var _items = []
var _rows = []
var _cols = []


func reset():
	_items = []
	_rows = []
	_cols = []


func prepare_size(size: int):
	_items.resize(size)


func register_connection(from_code, from_subcode, to_code):
	var roadmap = GridStatsRoadmap.new()
	
	# start
	var from_item = get_item(from_code)
	roadmap.add_step(
		from_item.depth, from_item.col_index,
		0, 0,
		true
	)

	# out to free column roadline
	var from_item_column_stats = get_col(from_item.depth)
	var free_out_col_roadline = from_item_column_stats.get_next_out()+1
	roadmap.add_step(
		from_item.depth, from_item.col_index,
		free_out_col_roadline, 0,
		true
	)
	
	# up/down to free row roadline
	var to_item = get_item(to_code)
	var row_index = from_item.col_index + sign(to_item.col_index - from_item.col_index)
	var row_stats = get_row(row_index)
	var free_row_roadline = row_stats.get_next_roadline()+1
	roadmap.add_step(
		from_item.depth, row_index,
		free_out_col_roadline, free_row_roadline
	)
	
	# horizontal to free column roadline
	var to_item_column_stats = get_col(to_item.depth)
	var free_in_roadline = -(to_item_column_stats.get_next_in()+1)
	roadmap.add_step(
		to_item.depth, row_index,
		free_in_roadline, free_row_roadline
	)
	
	# up/down to item
	roadmap.add_step(
		to_item.depth, to_item.col_index,
		free_in_roadline, 0
	)
	
	# connect (in) to item
	roadmap.add_step(
		to_item.depth, to_item.col_index,
		0, 0
	)
	
	to_item.add_connection(from_code, from_subcode, roadmap)


func register_item(code, main_parent):
	var item = GridStatsItem.new()
	var parent_item = get_item(main_parent)
	
	item.main_parent = main_parent
	item.depth = parent_item.depth + 1
	
	_items[code] = item
	
	var col = _add_item_to_col(item)
	item.col_index = col.items_count


func register_choice_count(row_index, choice_count):
	var row = get_row(row_index)
	
	if row.max_choice_count < choice_count:
		row.max_choice_count = choice_count


func register_max_real_height_in_row(row_index, real_height):
	var row = get_row(row_index)
	
	if row.max_real_height < real_height:
		row.max_real_height = real_height


func register_max_real_width_in_col(col_index, real_width):
	var col = get_col(col_index)
	
	if col.max_real_width < real_width:
		col.max_real_width = real_width


func get_summary_roadlines_in_row(row_index):
	return get_row(row_index).roadline_count + 1


func get_row_max_real_height(row_index):
	return get_row(row_index).max_real_height


func get_summary_roadlines_in_col(col_index):
	var col = get_col(col_index)
	return col.out_count + col.in_count + 2


func get_in_roadlines_in_col(col_index):
	var col = get_col(col_index)
	return col.in_count + 1


func get_col_max_real_width(col_index):
	return get_col(col_index).max_real_width


func has_item(code) -> bool:
	return _items.size() > code && _items[code] != null


func get_item(code):
	var item = _items[code]
	
	if not item:
		return GridStatsItem.new()
	else:
		return item


func _add_item_to_col(item):
	var col = get_col(item.depth)
	
	col.items_count += 1
	
	return col


func get_col(col_num):
	return _get_from(col_num, _cols, GridStatsCol)


func get_row(row_num):
	return _get_from(row_num, _rows, GridStatsRow)


func _get_from(from_index, from, fill_class):
	if from.size() <= from_index:
		from.resize(from_index + 1)
		
	var from_item = from[from_index]
	
	if not from_item:
		from_item = fill_class.new()
		from[from_index] = from_item
		
	return from_item
