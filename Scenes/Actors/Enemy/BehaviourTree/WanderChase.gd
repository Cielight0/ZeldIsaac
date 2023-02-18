extends StateMachine
class_name WanderState

func _ready()->void:
	super._ready()
	$Wait.wait_time_finished.connect(_on_wait_wait_time_finished)

func enter_state() -> void:
	if owner.statemachine == null:
		return

	owner.statemachine.set_state("Idle")

func _on_wait_wait_time_finished()->void:
	set_state("GoTo")
