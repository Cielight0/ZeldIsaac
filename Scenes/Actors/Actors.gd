extends CharacterBody2D
class_name Actor
@export var speed = 200
@export var friction = 1
@export var acceleration = 1

@onready var animated_sprite = $AnimatedPlayer
@onready var attack_hitbox = $AttackHitbox
@onready var audiostream = $AudioStreamPlayer2D

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
signal moving_direction_changed

### ACCESSORS###
@export var state : int = STATE.IDLE:
	set(value):
		if value != state:
			state = value
			emit_signal("state_changed")
	get:
		return state

@export var facing_direction := Vector2.DOWN:
	set(value):
		if value !=facing_direction:
			facing_direction = value
			emit_signal("facing_direction_changed")
	get:
		return facing_direction

@export var moving_direction := Vector2.DOWN:
	set(value):
		if value !=moving_direction:
			moving_direction = value
			emit_signal("moving_direction_changed")

### LOGIC ###

func _find_dir_name(dir: Vector2) -> String:
	var direction = ""
	for dir_name in dir_dict:
		if dir_dict[dir_name] == dir:
			direction = dir_name
			break
	return direction 
	
func _hitbox_direction():
	var angle = facing_direction.angle()-PI/2
	attack_hitbox.set_rotation(angle)

func _attack_effect()->void:
	var bodies_array=attack_hitbox.get_overlapping_bodies()
	audiostream.play()
	print(bodies_array)
	for body in bodies_array:
		if body.has_method("destroy"):
			body.destroy()

func update_animation():
	var dir_name = _find_dir_name(facing_direction)
	var state_name=""
	
	match(state):
		STATE.IDLE: state_name = "Idle"
		STATE.MOVE : state_name = "Move"
		STATE.ATTACK : state_name = "Attack"
	animated_sprite.play(state_name+dir_name)

### SIGNAL RESPONSES###

func _on_animated_player_animation_finished():
	if "Attack".is_subsequence_of(animated_sprite.get_animation()):
		state=STATE.IDLE

func _on_facing_direction_changed():
	_hitbox_direction()
	if state != STATE.ATTACK:
		update_animation()

func _on_moving_direction_changed():
	if moving_direction == Vector2.ZERO or moving_direction == facing_direction:
		return
	if moving_direction.x != 0 and moving_direction.y !=0:
	
		if moving_direction.x == facing_direction.x:
			facing_direction = Vector2(0,moving_direction.y)
		else: 
			facing_direction = Vector2(moving_direction.x,0)
	else:
		facing_direction = moving_direction


func _on_animated_player_animation_changed():
	pass


func _on_state_changed():
	pass # Replace with function body.
