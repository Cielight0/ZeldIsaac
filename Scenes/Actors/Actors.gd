extends CharacterBody2D
class_name Actor
@export var speed = 200
@export var friction = 1
@export var acceleration = 1

@onready var statemachine = $StateMachine
@onready var animated_sprite = $AnimatedPlayer
@onready var attack_hitbox = $AttackHitbox
@onready var audiostream = $AudioStreamPlayer2D

var moving_direction := Vector2.ZERO : set = set_moving_direction, get = get_moving_direction
var facing_direction := Vector2.DOWN : set = set_facing_direction, get = get_facing_direction

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
func set_facing_direction(value: Vector2) -> void:
	if facing_direction != value:
		facing_direction = value
		emit_signal("facing_direction_changed")
func get_facing_direction() -> Vector2:
	return facing_direction

func set_moving_direction(value: Vector2) -> void:
	if value != moving_direction:
		moving_direction = value
		emit_signal("moving_direction_changed")
func get_moving_direction() -> Vector2:
	return moving_direction

### Connections ###
func _ready() -> void:
	statemachine.state_changed.connect(_on_state_changed)
	facing_direction_changed.connect(_on_facing_direction_changed)
	moving_direction_changed.connect(_on_moving_direction_changed)
	animated_sprite.animation_changed.connect(_on_animated_player_animation_changed)
	animated_sprite.frame_changed.connect(_on_animated_player_frame_changed)
	animated_sprite.animation_finished.connect(_on_animated_player_animation_finished)
	
	statemachine.set_state("Idle")
	
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
	var state_name=statemachine.get_state_name()
	
	if state_name != "":
		animated_sprite.play(state_name+dir_name)
		print(state_name+dir_name)

### SIGNAL RESPONSES###

func _on_animated_player_animation_finished():
	if "Attack".is_subsequence_of(animated_sprite.get_animation()):
		statemachine.set_state("Idle")

func _on_facing_direction_changed():
	_hitbox_direction()
	if statemachine.get_state_name() != "Attack":
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

func _on_state_changed(_new_state:Node)->void:
	update_animation()

func _on_animated_player_frame_changed():
	if animated_sprite.frame == 2:
		if "Attack".is_subsequence_of(animated_sprite.get_animation()):
			_attack_effect()


func _on_animated_player_animation_changed():
	pass
