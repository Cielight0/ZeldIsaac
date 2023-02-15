extends State
class_name ActorMoveState

func update(_delta)->void:
	owner.move_and_slide()
