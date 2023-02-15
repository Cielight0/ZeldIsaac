extends State
class_name ChaseState

func enter_state() -> void:
	owner.statemachine.set_state("Move")

func update(_delta:float)->void:
	owner._update_move_path(owner.target.global_position)
