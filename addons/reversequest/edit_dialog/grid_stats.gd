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
	var from_item = get_item(from_code)
	var to_item = get_item(to_code)
	var from_item_column_stats = _get_col(from_item.depth+1)
	var from_item_row_stats = _get_row(from_item.col_index)
	var to_item_column_stats = _get_col(to_item.depth)
	var to_item_row_stats = _get_row(to_item.col_index)
	
	var roadmap = GridStatsRoadmap.new()
	
	roadmap.add_step(GridStatsRoadmapItem.TYPE_START, from_item.depth+1, from_item.col_index)
	roadmap.add_step(GridStatsRoadmapItem.TYPE_PICK_COLUMN, from_item.depth+1, 0)
	roadmap.add_step(GridStatsRoadmapItem.TYPE_PICK_COLUMN_ROAD, from_item_column_stats.get_next_out(), 0)
	roadmap.add_step(GridStatsRoadmapItem.TYPE_PICK_ROW, 0, from_item.col_index + sign(to_item.col_index - from_item.col_index))
	roadmap.add_step(GridStatsRoadmapItem.TYPE_PICK_ROW_ROAD, 0, from_item_row_stats.get_next_roadline())
	roadmap.add_step(GridStatsRoadmapItem.TYPE_PICK_COLUMN, to_item.depth, 0)
	roadmap.add_step(GridStatsRoadmapItem.TYPE_PICK_COLUMN_ROAD, to_item_column_stats.get_next_in(), 0)
	roadmap.add_step(GridStatsRoadmapItem.TYPE_PICK_ROW, 0, to_item.col_index)
	roadmap.add_step(GridStatsRoadmapItem.TYPE_END, to_item.depth, to_item.col_index)
	
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
	var row = _get_row(row_index)
	
	if row.max_choice_count < choice_count:
		row.max_choice_count = choice_count


func register_max_real_height_in_row(row_index, real_height):
	var row = _get_row(row_index)
	
	if row.max_real_height < real_height:
		row.max_real_height = real_height


func register_max_real_width_in_col(col_index, real_width):
	var col = _get_col(col_index)
	
	if col.max_real_width < real_width:
		col.max_real_width = real_width


func get_summary_roadlines_in_row(row_index):
	return _get_row(row_index).roadline_count + 1


func get_row_max_real_height(row_index):
	return _get_row(row_index).max_real_height


func get_summary_roadlines_in_col(col_index):
	var col = _get_col(col_index)
	return col.out_count + col.in_count + 2


func has_item(code) -> bool:
	return false


func get_item(code):
	var item = _items[code]
	
	if not item:
		return GridStatsItem.new()
	else:
		return item


func _add_item_to_col(item):
	var col = _get_col(item.depth)
	
	col.items_count += 1
	
	return col


func _get_col(col_num):
	return _get_from(col_num, _cols, GridStatsCol)


func _get_row(row_num):
	return _get_from(row_num, _rows, GridStatsRow)


func _get_from(from_index, from, fill_class):
	if from.size() <= from_index:
		from.resize(from_index + 1)
		
	var from_item = from[from_index]
	
	if not from_item:
		from_item = fill_class.new()
		from[from_index] = from_item
		
	return from[from_index]
