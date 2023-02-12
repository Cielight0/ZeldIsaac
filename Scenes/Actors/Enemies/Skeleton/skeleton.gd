extends Enemy
class_name Skeleton

func _ready()-> void:
	print("hello je suis un squelette !")
	

#func _physics_process(_delta):
##Fonction à découpler
#	moving_direction = Vector2(50,50)
#	if moving_direction.length() > 0 and state != STATE.ATTACK:
#		velocity = velocity.lerp(moving_direction.normalized() * speed, acceleration)
#	else:
#		velocity = velocity.lerp(Vector2.ZERO, friction)
#	move_and_slide()
