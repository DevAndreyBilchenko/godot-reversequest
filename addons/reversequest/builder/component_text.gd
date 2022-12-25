extends Control

signal new_size(size)

var get_size_limit #must be a funcref
var _font

onready var _text_edit = $TextEdit


func _ready():
	_font = _text_edit.get_font("font", "TextEdit")


func _on_text_changed():
	var limit = get_size_limit.call_func().x
	var text = str(_text_edit.text, " W")
	var string_size = _font.get_string_size(text)
	if string_size.x > limit:
		string_size = _font.get_wordwrap_string_size(text, limit)
	
	emit_signal("new_size", string_size)
