extends Label

func _ready():
	get_parent().state_changed.connect(_on_StateMachine_State_changed)
	_update_text(get_parent().current_state)
	
func _update_text(state: Node)->void:
	set_text(str(state))

func _on_StateMachine_State_changed(state : Node)->void:
	_update_text(state)
