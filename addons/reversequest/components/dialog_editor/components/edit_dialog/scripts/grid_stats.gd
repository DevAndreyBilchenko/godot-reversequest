extends Reference

# количество треков в горизонтальном пролете
var rows_size = []

# количество треков в вертикальном пролете
var cols_size = []

# количество элементов в вертикальном пролете
var cols_depth = []

var element_positions = {}

var roadline_navpath = {}

var deffered_check = {}

func reset():
	for n in rows_size.size():
		rows_size[n] = 0
		
	for n in cols_size.size():
		cols_size[n] = 0
		
	for n in cols_depth.size():
		cols_depth[n] = 0
	
	element_positions.clear()
	deffered_check.clear()
	roadline_navpath.clear()


func register_element(col, code):
	update_arr_size("cols_depth", col+1)
	cols_depth[col] += 1
	element_positions[code] = Vector2(col, cols_depth[col] - 1)
	check_deffered(code)


func check_deffered(code):
	if deffered_check.has(code):
		var remove_values = []
		var to_pos = get_element_position(code)
		var from_items = deffered_check.get(code, [])
		
		for from_item in from_items:
			var from_pos = get_element_position(from_item.from_code)
			if from_pos != null:
				remove_values.append(from_item)
				register_col_roadline(from_pos.x)
				register_col_roadline(to_pos.x - 1)
				var row_pos = to_pos.y - 1
				if to_pos.y <= from_pos.y:
					row_pos = to_pos.y
				register_row_roadline(row_pos)
				
				roadline_navpath[get_roadline_key(from_item.choice_code, from_item.from_code)] = [
					cols_size[from_pos.x], # вертикальный трек на выходе
					row_pos, # горизонтальная позиция
					rows_size[row_pos], # горизонтальный трек
					cols_size[to_pos.x - 1] # Вертикальный трек на входе
				]
		
		for v in remove_values:
			from_items.erase(v)


func register_roadline_deffered(choice_code, from_code, to_code):
	print("register_", choice_code, "_", from_code, "_to_", to_code)
	
	if not deffered_check.has(to_code):
		deffered_check[to_code] = []
	
	deffered_check[to_code].append({
		"from_code": from_code,
		"choice_code": choice_code
	})
	
	if get_element_position(to_code):
		check_deffered(to_code)


func get_roadline_navpath(choice_code, from_code):
	return roadline_navpath[get_roadline_key(choice_code, from_code)]


func get_roadline_key(choice_code, from_code):
	return str(choice_code, "_", from_code)


func register_row_roadline(row_index):
	update_arr_size("rows_size", row_index+1)
	rows_size[row_index] += 1


func register_col_roadline(col_index):
	update_arr_size("cols_size", col_index+1)
	cols_size[col_index] += 1


func update_arr_size(arr_name, size):
	if self[arr_name].size() < size:
		var old = self[arr_name].size()
		self[arr_name].resize(size)
		
		for i in range(old, size):
			self[arr_name][i] = 0


func get_element_position(code):
	return element_positions.get(code, null)


func get_summary_roadlines_upper_row(row):
	var summary = 0
	
	if row <= rows_size.size():
		for i in row:
			summary += rows_size[i]
		
	return summary
	

func get_summary_roadlines_left_col(col):
	var summary = 0
	
	if col <= cols_size.size():
		for i in col:
			summary += cols_size[i]
		
	return summary


func get_row_items(row_index):
	var items = []
	for key in element_positions.keys():
		if element_positions[key].y == row_index:
			items.append(key)
	
	return items
