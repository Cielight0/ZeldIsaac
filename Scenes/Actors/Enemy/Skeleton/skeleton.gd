extends Enemy
class_name Skeleton

func _ready():
	statemachine.state_changed.connect(_on_state_changed)
	facing_direction_changed.connect(_on_facing_direction_changed)
	moving_direction_changed.connect(_on_moving_direction_changed)
	animated_sprite.animation_changed.connect(_on_animated_player_animation_changed)
	animated_sprite.frame_changed.connect(_on_animated_player_frame_changed)
	animated_sprite.animation_finished.connect(_on_animated_player_animation_finished)
	
	statemachine.set_state("Attack")
