extends StaticBody2D

@onready var animated_sprite = $AnimatedSprite
@onready var collision_shape = $CollisionShape

enum STATE{
	IDLE,
	BREAKING,
	BROKEN
}

var state : int = STATE.IDLE

func destroy()->void:
	if state == STATE.IDLE:
		state = STATE.BREAKING
		animated_sprite.play("Breaking")
		

func _on_animated_sprite_animation_finished():
	if animated_sprite.get_animation() == "Breaking":
		state = STATE.BROKEN
		collision_shape.set_disabled(true)
