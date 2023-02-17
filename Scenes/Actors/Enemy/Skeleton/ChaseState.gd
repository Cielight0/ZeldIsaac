extends State
class_name ChaseState

func enter_state() -> void:
	owner.statemachine.set_state("Move")

func update(_delta:float)->void:
	if owner.target == null:
		return
	else:
		owner._update_move_path(owner.target.position)

