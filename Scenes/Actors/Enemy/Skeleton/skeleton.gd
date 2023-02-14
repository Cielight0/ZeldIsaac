extends Enemy
class_name Skeleton

func _ready():
	super._ready()
	statemachine.set_state("Attack")
