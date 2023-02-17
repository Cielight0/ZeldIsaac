extends Actor
class_name Character
@onready var input := Vector2.ZERO



### INPUTS ###
func get_input():

	input.x = int(Input.is_action_pressed('ui_right'))-int(Input.is_action_pressed('ui_left'))
	input.y = int(Input.is_action_pressed('ui_down'))-int(Input.is_action_pressed('ui_up'))
	
	if Input.is_action_just_pressed('ui_accept'):
		statemachine.set_state("Attack")
	if moving_direction != Vector2.ZERO and statemachine.get_state_name() != "Attack":
		statemachine.set_state("Move")
	if moving_direction == Vector2.ZERO and statemachine.get_state_name() != "Attack":
		statemachine.set_state("Idle")
	return input
	
	
### LOGIC ###


func _physics_process(_delta):
#Fonction à découpler
	moving_direction = get_input()
	if moving_direction.length() > 0 :
		velocity = velocity.lerp(moving_direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	
func _interaction_attempt():
	var bodies_array=attack_hitbox.get_overlapping_bodies()
	print(bodies_array)
	for body in bodies_array:
		if body.has_method("interact") and body.state_machine.get_state_name() == "Closed":
			body.interact()
			return true
	return false

###SIGNAL RESPONSES###

func _on_state_changed(_new_state:Node)->void:
	if statemachine.get_state_name() == "Attack":
		if _interaction_attempt()==true:
			statemachine.set_state("Idle")
		else:
			statemachine.set_state("Attack")
	super._on_state_changed(_new_state)

