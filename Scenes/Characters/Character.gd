extends CharacterBody2D

@export var speed = 250
@export var friction = 1
@export var acceleration = 1
@onready var animated_sprite = get_node("AnimatedPlayer")

var moving_direction := Vector2.ZERO
var facing_direction := Vector2.DOWN

var is_attacking :bool = false
var is_moving :bool = false
var is_idleing :bool = true

var dir_dict : Dictionary = {
	"Left": Vector2.LEFT,
	"Right": Vector2.RIGHT,
	"Up": Vector2.UP,
	"Down": Vector2.DOWN
}

func get_input():
	var input = Vector2()
	#bool isAttacking = false
	if Input.is_action_pressed('ui_right'):
		input.x+= 1
	if Input.is_action_pressed('ui_left'):
		input.x-= 1
	if Input.is_action_pressed('ui_down'):
		input.y+= 1
	if Input.is_action_pressed('ui_up'):
		input.y-= 1
	if Input.is_action_just_pressed('ui_accept'):
		is_attacking = true
		print("attack")
	return input
	
func _find_dir_name(dir: Vector2) -> String:
	var dir_values_array = dir_dict.values()
	var dir_index = dir_values_array.find(dir)
	if dir_index ==-1:
		return ""
		
	var dir_keys_array = dir_dict.keys()
	var dir_keys = dir_keys_array[dir_index]
	
	return dir_keys

func _physics_process(_delta):
	var moving_direction = get_input()
	if moving_direction != Vector2.ZERO:
		facing_direction = moving_direction
			
	var dir_name = _find_dir_name(facing_direction)
	#Attack animations
	if is_attacking == true:
		is_idleing = false
		animated_sprite.play("Attack"+dir_name)	
	#Idle animation
	else:
		if moving_direction == Vector2.ZERO:
			is_idleing = true
			animated_sprite.stop()
		else:
			is_moving= true
			animated_sprite.play("Move"+dir_name)

	#moves animation
	if moving_direction.length() > 0:
		velocity = velocity.lerp(moving_direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
		
	move_and_slide()

func _on_animated_player_animation_finished():
	if "Attack".is_subsequence_of(animated_sprite.get_animation()):
		is_attacking=false
		print("attackfinish")
