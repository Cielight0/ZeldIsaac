extends State
class_name WaitState

@export var min_wait_time : float = 0.8
@export var max_wait_time : float = 1.2

signal wait_time_finished

func _ready()->void:
	wait_time_finished.connect(_on_Timer_timeout)

func enter_state()->void:
	var wait_time = randf_range(min_wait_time, max_wait_time)
	$Timer.start(wait_time)

func _on_Timer_timeout()->void:
	emit_signal("wait_time_finished")
