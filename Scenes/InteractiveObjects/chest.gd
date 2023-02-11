extends StaticBody2D

@onready var animated_sprite = $AnimatedSprite
@onready var collision_shape = $CollisionShape

enum STATE{
	CLOSED,
	OPENNING,
	OPENED
}

var state : int = STATE.CLOSED

func interact():
	if state == STATE.CLOSED:
		state = STATE.OPENNING
		animated_sprite.play("Openning")
		
func _spawn_content()->void:
	EVENTS.emit_signal("spawn_coin",position)
	print(position)

func _on_animated_sprite_animation_finished():
	if animated_sprite.get_animation() == "Openning":
		state = STATE.OPENED
		_spawn_content()
		print("opened")
