extends Node
class_name State

@onready var statemachine = get_parent()

func enter_state()->void:
	pass
	
func exit_state()->void:
	pass
	
func update(_delta:float)->void:
	pass

func is_current_state()->bool:
	return statemachine.get_state() == self
