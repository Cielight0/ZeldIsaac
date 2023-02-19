extends State
class_name WaitState

@export var min_wait_time : float = 0.8
@export var max_wait_time : float = 1.2

@onready var timer = $WaitTimer

signal wait_time_finished

func _ready()->void:
	timer.timeout.connect(_on_Timer_timeout)
	print("ready")
	
func enter_state()->void:
	if owner.statemachine != null:
		owner.statemachine.set_state("Idle")
	var wait_time = randf_range(min_wait_time, max_wait_time)
	timer.start(wait_time)
	
func _on_Timer_timeout()->void:
	print("wait timer timeout")
	emit_signal("wait_time_finished")
