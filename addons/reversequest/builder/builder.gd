extends HFlowContainer

export(PackedScene) var Holder
export(PackedScene) var ComponentText

onready var _menu_button = $MenuButton

enum {C_TEXT, C_COND}

func _ready():
	_menu_button.get_popup().connect("id_pressed", self, "_on_menu_component_pick")


func _on_menu_component_pick(id):
	if id == C_TEXT:
		var holder = Holder.instance()
		holder.add_component(ComponentText.instance())
		add_child_below_node(get_child(0), holder)
