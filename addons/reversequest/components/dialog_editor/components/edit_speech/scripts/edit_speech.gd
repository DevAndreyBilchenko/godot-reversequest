extends CanvasLayer

signal cancel
signal apply(speech_res)
onready var speech = $Speech
onready var text = $Speech/MarginContainer/HBoxContainer/VBoxContainer/TextEdit
var res

func open(speech_res):
	res = speech_res
	fill()
	speech.show()

func close():
	speech.hide()

func fill():
	text.text = res.text

func _on_Apply_pressed():
	emit_signal("apply", res)

func _on_Cancel_pressed():
	emit_signal("cancel")

func _on_TextEdit_text_changed():
	res.text = text.text
