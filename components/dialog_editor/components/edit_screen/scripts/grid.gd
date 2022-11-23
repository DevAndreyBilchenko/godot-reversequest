extends Reference

var _rows_height := PoolRealArray() #сверху-вниз
var _cols_width := PoolRealArray() #слева-направо
var _iterated := PoolIntArray()


func set_row_count(rows_count):
	if _rows_height.size() != rows_count:
		_rows_height.resize(rows_count)


func set_row_height(row: int, size: float):
	_rows_height.set(row - 1, size)


func get_row_height(row: int):
	return _rows_height[row - 1]


func set_col_count(col_count):
	if _cols_width.size() != col_count:
		_cols_width.resize(col_count)


func set_col_width(col: int, width: float):
	_cols_width.set(col - 1, width)


func get_col_width(col: int):
	return _cols_width[col - 1]


func update(dialog):
	_iterated.resize(dialog.get_speech_count())
	_update_iterator(dialog.get_root_speech(), 1, 1)


func _update_iterator(speech, row, col):
	pass
