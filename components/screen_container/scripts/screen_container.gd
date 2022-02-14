extends Container
tool
class_name ScreenContainer

var last_size

func _ready():
	if not Engine.editor_hint:
		last_size = get_viewport().get_size();
	fit_size()
	
func _process(_delta):
	if not Engine.editor_hint:
		if last_size != get_viewport().get_size():
			last_size = get_viewport().get_size()
			fit_size();

func fit_size():
	if Engine.editor_hint:
		rect_size = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
	else:
		rect_size = last_size
