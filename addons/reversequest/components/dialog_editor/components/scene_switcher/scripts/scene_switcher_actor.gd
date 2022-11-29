extends Node

export(Array, String) var group
export(NodePath) var target
export(String) var signal_name
export(Array) var send_data
export(String, FILE, "*.tscn") var scene_file_path
export(bool) var scene_preload = false
export(bool) var use_history
export(String, "Back", "Front") var history

var _packed_scene
var _controller


func run():
	_on_target_action()


func _ready():
	for g in group:
		print("add_group ", g)
		add_to_group(g)
	
	self.call_deferred("_setup")


func bind_controller(controller_node):
	_controller = controller_node


func _setup():
	get_node(target).connect(signal_name, self, "_on_target_action")


func _on_target_action():
	if use_history:
		match history:
			"Back":
				_controller.back()
			"Front":
				#not implemented
				pass
		return
		
	_controller.switch_to(scene_file_path, send_data)

