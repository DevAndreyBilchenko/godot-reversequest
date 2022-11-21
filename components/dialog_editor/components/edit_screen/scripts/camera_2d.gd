extends Camera2D

export var speed = 300
export var boost = 600
export var scale_power = 0.1

func _process(delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		direction.x = -1
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	if Input.is_action_pressed("ui_down"):
		direction.y = 1

	position += (speed * delta * direction)

	if Input.is_action_just_released("ui_scroll_up"):
		zoom = (zoom - Vector2(scale_power, scale_power))
	
	if Input.is_action_just_released("ui_scroll_down"):
		zoom = (zoom + Vector2(scale_power, scale_power))
