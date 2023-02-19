extends StateMachine
class_name WanderState

@export var min_wander_distance = 40
@export var max_wander_distance = 70

@onready var wait = $Wait

func _ready()->void:
	super._ready()
	wait.wait_time_finished.connect(_on_wait_wait_time_finished)
	owner.move_path_finished.connect(_on_Enemy_move_path_finished)

###Virtuals###

###logic###
func _generate_new_destination()->Vector2:
	var angle = randf_range(0,360)
	var direction = Vector2(sin(angle),cos(angle))
	var distance = randf_range(min_wander_distance, max_wander_distance)
	
	return owner.global_position + direction*distance

###signal_responses###

func _on_wait_wait_time_finished()->void:
	var destination = _generate_new_destination()
	owner._update_move_path(destination)
	print("wait finished re	ady to move")
	set_state("GoTo")

func _on_Enemy_move_path_finished()->void:
	if is_current_state():
		set_state("Wait")
		
