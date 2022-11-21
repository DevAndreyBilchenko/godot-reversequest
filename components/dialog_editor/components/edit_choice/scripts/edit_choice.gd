extends CanvasLayer

signal cancel
signal apply(speech_code, choice_res)

var res
var code

onready var text = $Choice/MarginContainer/HBoxContainer/VBoxContainer/TextEdit
onready var choice = $Choice

func open(speech_code, choice_res):
	code = speech_code
	res = choice_res
	fill()
	choice.show()

func close():
	choice.hide()

func fill():
	text.text = res.text

func _on_Cancel_pressed():
	emit_signal("cancel")

func _on_Apply_pressed():
	emit_signal("apply", code, res)

func _on_TextEdit_text_changed():
	res.text = text.text
