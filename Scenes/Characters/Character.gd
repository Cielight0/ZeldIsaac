extends CharacterBody2D

@export var speed = 250
@export var friction = 1
@export var acceleration = 1
@onready var animated_sprite = get_node("AnimatedPlayer")

enum STATE {
	IDLE,
	MOVE,
	ATTACK
}

var dir_dict : Dictionary = {
	"Left": Vector2.LEFT,
	"Right": Vector2.RIGHT,
	"Up": Vector2.UP,
	"Down": Vector2.DOWN
}

signal state_changed
signal facing_direction_changed

### ACCESSORS###
@export var state : int = STATE.IDLE:
	set(value):
		if value != state:
			state = value
			print("state changed")
			emit_signal("state_changed")
	get:
		return state

@export var facing_direction := Vector2.DOWN:
	set(value):
		if value !=facing_direction:
			facing_direction = value
			print("facing direction changed")
			emit_signal("facing_direction_changed")
	get:
		return facing_direction
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
		state = STATE.ATTACK
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
		state = STATE.MOVE
		
	if moving_direction == Vector2.ZERO and state != STATE.ATTACK:
		state = STATE.IDLE

	if moving_direction.length() > 0:
		velocity = velocity.lerp(moving_direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
		
	move_and_slide()

func update_animation():
	var dir_name = _find_dir_name(facing_direction)
	var state_name=""
	
	match(state):
		STATE.IDLE: state_name = "Idle"
		STATE.MOVE : state_name = "Move"
		STATE.ATTACK : state_name = "Attack"
	animated_sprite.play(state_name+dir_name)
		
	print("Animation update !")

func _on_animated_player_animation_finished():
	if "Attack".is_subsequence_of(animated_sprite.get_animation()):
		state=STATE.IDLE

func _on_state_changed():
	update_animation()

func _on_direction_changed():
	update_animation()
