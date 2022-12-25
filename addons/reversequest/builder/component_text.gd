extends Control

signal new_size(size)

var ComponentValue = preload("res://addons/reversequest/builder/component_value.gd")
var ComponentType = preload("res://addons/reversequest/builder/component_type.gd")

var value setget _set_value, _get_value
var get_size_limit #must be a funcref
var _font
var _value_container

onready var _text_edit = $TextEdit


func _ready():
	_font = _text_edit.get_font("font", "TextEdit")
	
	if not _value_container:
		_fill_empty_value()
		
	_fill_component_from_value_container()


func _set_value(v):
	_value_container = v


func _on_text_changed():
	var limit = get_size_limit.call_func().x
	var text = str(_text_edit.text, " W")
	var string_size = _font.get_string_size(text)
	
	if string_size.x > limit:
		string_size = _font.get_wordwrap_string_size(text, limit)
	
	_value_container.value = _text_edit.text
	
	emit_signal("new_size", string_size)


func _get_value():
	return _value_container


func _fill_empty_value():
	_value_container = ComponentValue.new()
	_value_container.type = ComponentType.TEXT
	_value_container.value = ""


func _fill_component_from_value_container():
	_text_edit.text = _value_container.value
