extends Control

var res

onready var store = $SceneSwitcherStore


func _ready():
	res = store.send_data[0]
