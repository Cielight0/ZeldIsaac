extends StaticBody2D

@onready var animated_sprite = $AnimatedSprite
@onready var collision_shape = $CollisionShape

@onready var state_machine = $StateMachine


func _ready():
	animated_sprite.animation_finished.connect(_on_animated_sprite_animation_finished)
	
func interact():
	if state_machine.get_state_name() == "Closed":
		print("le coffre est fermé")
		state_machine.set_state("Openning")
		animated_sprite.play("Openning")
		
func _spawn_content()->void:
	EVENTS.emit_signal("spawn_coin",position)
	print(position)

func _on_animated_sprite_animation_finished():
	if animated_sprite.get_animation() == "Openning":
		state_machine.set_state("Opened")
		_spawn_content()
		print("opened")
