extends Control

onready var store = $SceneSwitcherStore


var res


func _ready():
	res = store.send_data[0]
