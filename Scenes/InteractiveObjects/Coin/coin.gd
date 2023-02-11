extends Node2D

@onready var area = $Area2D
@onready var particules = $GPUParticles2D
@onready var audiostream = $AudioStreamPlayer2D
@onready var coinsprite = $CoinSprite
@onready var shadowsprite = $ShadowSprite
@onready var animation_player = $AnimationPlayer

enum STATE{
	SPAWN,
	IDLE,
	FOLLOW,
	COLLECT
}

var speed : float = 400
var state : int = STATE.IDLE
var target : Node2D = null

func _ready()-> void:
	animation_player.play("wave")


func _physics_process(delta)->void:
	particules.set_emitting(false)

	if state == STATE.FOLLOW:
		print(target.get_position())
		var target_pos = target.get_position()
		var spd = speed * delta

		if position.distance_to(target_pos) < spd:
			position = target_pos
			print(position)
			collect()
		else:
			position = position.move_toward(target_pos,spd)

func collect():
	state = STATE.COLLECT
	coinsprite.set_visible(false)
	shadowsprite.set_visible(false)
	particules.set_emitting(true)
	audiostream.play()
	EVENTS.emit_signal("coin_collected")


func _on_area_2d_body_entered(body):
	if state == STATE.IDLE and body is Character:
		state = STATE.FOLLOW
		target = body
		animation_player.stop()


func _on_audio_stream_player_2d_finished():
	queue_free()
	print("clear")


func _on_animation_player_animation_finished():
	if coinsprite.get_animation():
		coinsprite.play("Idle")
		shadowsprite.play("Idle")


func _on_timer_timeout():
	coinsprite.play("Rotation")
	shadowsprite.play("Rotation")	
