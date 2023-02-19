extends State

func enter_state()->void:
	owner.statemachine.set_state("Move")

