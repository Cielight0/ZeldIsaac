extends Actor
class_name Character
@onready var input := Vector2.ZERO
### INPUTS ###
func get_input():

	input.x = int(Input.is_action_pressed('ui_right'))-int(Input.is_action_pressed('ui_left'))
	input.y = int(Input.is_action_pressed('ui_down'))-int(Input.is_action_pressed('ui_up'))
	
	if Input.is_action_just_pressed('ui_accept'):
		state = STATE.ATTACK
	if moving_direction != Vector2.ZERO and state != STATE.ATTACK:
		state = STATE.MOVE
	if moving_direction == Vector2.ZERO and state != STATE.ATTACK:
		state = STATE.IDLE
	return input
		
### LOGIC ###
func _physics_process(_delta):
#Fonction à découpler
	moving_direction = get_input()
	if moving_direction.length() > 0 and state != STATE.ATTACK:
		velocity = velocity.lerp(moving_direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()
	
func _interaction_attempt():
	var bodies_array=attack_hitbox.get_overlapping_bodies()
	print(bodies_array)
	for body in bodies_array:
		if body.has_method("interact") and body.state == body.STATE.CLOSED:
			print(body.state)
			body.interact()
			return true
	return false

###SIGNAL RESPONSES###

func _on_state_changed():
	if state == STATE.ATTACK:
		if _interaction_attempt()==true:
			state = STATE.IDLE
		else:
			state = STATE.ATTACK
	update_animation()

