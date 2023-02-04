extends CharacterBody2D
#github test
@export var speed = 200
@export var friction = 1
@export var acceleration = 1
@onready var animated_sprite = get_node("AnimatedPlayer")

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('ui_right'):
		input.x+= 1
	if Input.is_action_pressed('ui_left'):
		input.x-= 1
	if Input.is_action_pressed('ui_down'):
		input.y+= 1
	if Input.is_action_pressed('ui_up'):
		input.y-= 1
	return input
	

func _physics_process(_delta):
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
		print(direction)
		if direction==Vector2(0,1):
			animated_sprite.play("MoveDown")
		if direction==Vector2(0,-1):
			animated_sprite.play("MoveUp")
		if direction==Vector2(1,0):
			animated_sprite.play("MoveRight")
		if direction==Vector2(-1,0):
			animated_sprite.play("MoveLeft")
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
		animated_sprite.stop()
	move_and_slide()
