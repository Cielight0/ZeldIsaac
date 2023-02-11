extends StaticBody2D

@onready var animated_sprite = $AnimatedSprite
@onready var collision_shape = $CollisionShape
@onready var audiostream = $AudioStreamPlayer2D

enum STATE{
	IDLE,
	BREAKING,
	BROKEN
}

var state : int = STATE.IDLE

func destroy()->void:
	if state == STATE.IDLE:
		state = STATE.BREAKING
		audiostream.play()
		collision_shape.set_disabled(true)
		animated_sprite.play("Breaking")
		

func _on_animated_sprite_animation_finished():
	if animated_sprite.get_animation() == "Breaking":
		state = STATE.BROKEN
		#await get_tree().create_timer(30).timeout
		#queue_free()
