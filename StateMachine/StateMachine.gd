extends State
class_name StateMachine

var current_state : Node = null : set = set_state, get = get_state
var previous_state : Node = null : get = get_previous_state

signal state_changed(state)

###accessor##

func set_state(state)->void:
	if state is String:
		state = get_node_or_null(state)
	
	if state == current_state:
		return
	
	if current_state != null:
		state.exit_state()

	previous_state = current_state
	current_state = state
	
	if current_state != null:
		current_state.enter_state()
	
	emit_signal("state_changed", current_state)

func get_state()->Node: return current_state
func get_state_name()->String:
	if current_state == null:
		return ""
	return current_state.name
	
func get_previous_state()->Node : return previous_state

##built-in###

func _ready()->void:
	set_to_default_state()

func _physics_process(delta:float)->void:
		current_state.update(delta)

###virtual###
func enter_state()->void:
	set_to_default_state()
	
func exist_state()->void:
	set_state(null)
	
###logic###
func set_to_default_state()->void:
	set_state(get_child(0))