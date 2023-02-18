extends State
class_name AttackState

@onready var cooldown = $Cooldown

# Called when the node enters the scene tree for the first time.
func enter_state() -> void:
	owner.statemachine.set_state("Attack")
	cooldown.start()
	
func is_cooldown_runing()->bool:
	return !cooldown.is_stopped() && !cooldown.is_paused()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
