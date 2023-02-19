extends Node2D

@onready var area = $Area2D
@onready var particules = $GPUParticles2D
@onready var audiostream = $AudioStreamPlayer2D
@onready var coinsprite = $CoinSprite
@onready var shadowsprite = $ShadowSprite
@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer
@onready var SpawnDuration = $SpawnDurationTimer
@onready var state_machine = $StateMachine

signal state_changed

const GRAVITY := 40

var speed : float = 500
var target : Node2D = null

var spawn_v_force : float = -400
var spawn_dir_force : float = 50
var spawn_dir := Vector2.ZERO
var spawn_dir_velocity := Vector2.ZERO
var damping := 20


func _ready()-> void:
	area.body_entered.connect(_on_area_2d_body_entered)
	state_machine.state_changed.connect(_on_state_changed)
	audiostream.finished.connect(_on_audio_stream_player_2d_finished)
	SpawnDuration.timeout.connect(_on_spawn_duration_timer_timeout)
	timer.timeout.connect(_on_timer_timeout)
	
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)
	
	particules.set_emitting(false)
	animation_player.play("wave")
	_init_spawn_values()

func _init_spawn_values()-> void:
	var rdm_angle = deg_to_rad(randf_range(0, 360))
	spawn_dir = Vector2(sin(rdm_angle),cos(rdm_angle))
	

func _spawn(delta):
	spawn_v_force += GRAVITY
	var spawn_v_velocity = Vector2(0,spawn_v_force)
	spawn_dir_velocity = spawn_dir * spawn_dir_force
	var velocity = spawn_v_velocity + spawn_dir_velocity
	position += velocity*delta

func _physics_process(delta)->void:
	if state_machine.get_state_name() == "Follow":
		_follow(delta)
	if state_machine.get_state_name() == "Spawn":
		_spawn(delta)


func _follow(delta)->void:
	if state_machine.get_state_name() == "Follow":
		var target_pos = target.get_position()
		var spd = speed * delta

		if position.distance_to(target_pos) < spd:
			position = target_pos
			collect()
		else:
			position = position.move_toward(target_pos,spd)

func collect():
	state_machine.set_state("Collect")
	coinsprite.set_visible(false)
	shadowsprite.set_visible(false)
	particules.set_emitting(true)
	audiostream.play()
	EVENTS.emit_signal("coin_collected")


func _on_area_2d_body_entered(body):
	if state_machine.get_state_name() == "Idle" and body is Character:
		state_machine.set_state("Follow")
		target = body
		animation_player.stop()


func _on_audio_stream_player_2d_finished():
	queue_free()


func _on_animation_player_animation_finished():
	if coinsprite.get_animation():
		coinsprite.play("Idle")
		shadowsprite.play("Idle")


func _on_timer_timeout():
	coinsprite.play("Rotation")
	shadowsprite.play("Rotation")	


func _on_spawn_duration_timer_timeout():
	state_machine.set_state("Idle")


func _on_state_changed(_new_state:Node):
	if state_machine.get_state_name() == "Idle":
		for body in area.get_overlapping_bodies():
			print("ya un body !")
			if body is Character:
				state_machine.set_state("Follow")
				target = body
				animation_player.stop()
