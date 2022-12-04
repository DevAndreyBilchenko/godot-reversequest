extends Node

export(NodePath) var watch_target
export(String) var watch_prop
export(Array) var watch_values_ok
export(Array) var watch_values_no
export(String) var watch_signal
export(NodePath) var target
export(String) var target_prop
export(Array) var target_value_ok
export(Array) var target_value_no
export(Array) var target_timeout_value
export(float) var timeout = 0

var _initial = false
var _timer: Timer = null


func _ready():
	yield(get_tree(), "idle_frame")
	_initial_run()
	_setup()


func _setup():
	while true:
		var wtarget = get_node_or_null(watch_target)
		if wtarget == null:
			break
		else:
			yield(wtarget, watch_signal)
			_on_target_signal_emit(wtarget)


func _initial_run():
	_initial = true
	var wtarget = get_node_or_null(watch_target)
	if wtarget == null:
		return
	var _tm = timeout
	
	_on_target_signal_emit(wtarget)
	_initial = false


func _on_target_signal_emit(wtarget: Node):
	var status = false
	
	if not watch_prop:
		status = true
	else: 
		var wprop = wtarget.get_indexed(watch_prop)
		
		var okstatus = _check_status(watch_values_ok, wprop)
		var nostatus = _check_status(watch_values_no, wprop)
		
		status = okstatus
		
		if nostatus == true:
			status = false
	
	_update_prop(status)
	_run_timeout()


func _check_status(arr, prop):
	for v in arr:
		if v == prop:
			return true
	
	return false


func _run_timeout():
	if timeout == 0:
		return
		
	var mtarget = get_node(target)
	
	if mtarget.get_indexed(target_prop) == target_timeout_value[0]:
		return
	
	if _initial:
		_on_timer_timeout()
		return
	
	if _timer == null:
		_timer = Timer.new()
		_timer.wait_time = timeout
		_timer.one_shot = true
		_timer.connect("timeout", self, "_on_timer_timeout")
		add_child(_timer)
	
	_timer.start()


func _update_prop(status):
	var mtarget = get_node(target)
	var val
	
	if status:
		val = target_value_ok[0]
	else:
		val = target_value_no[0]
	
	mtarget.set_indexed(target_prop, val)


func _on_timer_timeout():
	var mtarget = get_node(target)
	mtarget.set_indexed(target_prop, target_timeout_value[0])
