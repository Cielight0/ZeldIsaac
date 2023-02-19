extends Enemy
class_name Skeleton

@onready var behaviour_tree = $BehaviourTree
@onready var chase_area = $ChaseArea
@onready var attack_area = $AttackArea


func _on_state_changed(_new_state:Node)->void:
	update_animation()

var target : Node2D
var path : Array = []

var target_in_chase_area : bool = false : set = set_target_in_chase_area
var target_in_attack_area : bool = false : set = set_target_in_attack_area

signal target_in_chase_area_changed
signal target_in_attack_area_changed
signal move_path_finished

###ACCESSOR###
func set_target_in_chase_area(value:bool)->void:
	if value != target_in_chase_area:
		target_in_chase_area = value
		emit_signal("target_in_chase_area_changed", target_in_chase_area)

func set_target_in_attack_area(value:bool)->void:
	if value != target_in_attack_area:
		target_in_attack_area = value
		print("target in attack area")
		emit_signal("target_in_attack_area_changed", target_in_attack_area)

###BUILT-IN###
func _ready():
	super._ready()
	chase_area.body_entered.connect(_on_ChaseArea_body_entered)
	chase_area.body_exited.connect(_on_ChaseArea_body_exited)
	attack_area.body_entered.connect(_on_AttackArea_body_entered)
	attack_area.body_exited.connect(_on_AttackArea_body_exited)
	target_in_chase_area_changed.connect(_on_ChaseArea_body_changed)
	target_in_attack_area_changed.connect(_on_AttackArea_body_changed)
	statemachine.state_changed.connect(_on_state_machine_state_changed)

###LOGIC###
func move_along_path(delta: float)->void:
	if path.is_empty():
		return
		
	var dir = global_position.direction_to(path[0])
	var dist = global_position.distance_to(path[0])
	
	moving_direction = dir
	
	if dist <= speed * delta:
		var __= move_and_collide(dir*dist)
		path.remove_at(0)
		
		if path.is_empty():
			emit_signal("move_path_finished")
	else:
		var __= move_and_collide(dir*speed*delta)

func _update_move_path(dest: Vector2)->void:
	path=[dest]

func _update_target()->void:
	if !target_in_chase_area && !target_in_attack_area:
		target = null

func _update_behaviour_state()->void:
	if can_attack():
		behaviour_tree.set_state("Attack")
	elif target_in_chase_area:
		behaviour_tree.set_state("Chase")
	else:
		behaviour_tree.set_state("Wander")

func can_attack()->bool:
	return !$BehaviourTree/Attack.is_cooldown_runing() && target_in_attack_area
	
###SIGNAL RESPONSES###
func _on_ChaseArea_body_entered(body: Node2D)->void:
	if body is Character:
		set_target_in_chase_area(true)
		target = body

func _on_ChaseArea_body_exited(body: Node2D)->void:
	if body is Character:
		set_target_in_chase_area(false)
		
func _on_AttackArea_body_entered(body: Node2D)->void:
	if body is Character:
		set_target_in_attack_area(true)
		target = body

func _on_AttackArea_body_exited(body: Node2D)->void:
	if body is Character:
		set_target_in_attack_area(false)
		_update_behaviour_state()
		
func _on_ChaseArea_body_changed(_value: bool)->void:
	_update_target()
	_update_behaviour_state()

func _on_AttackArea_body_changed(_value: bool)->void:
	_update_target()

	if target_in_attack_area:
		_update_behaviour_state()

func _on_moving_direction_changed():
	if abs(moving_direction.x) > abs(moving_direction.y):
		facing_direction = (Vector2(sign(moving_direction).x,0))
	else:
		facing_direction = (Vector2(0,sign(moving_direction).y))


func _on_state_machine_state_changed(state):
	if statemachine == null:
		return
	if state.name =="Idle" && statemachine.previous_state == $StateMachine/Attack:
		_update_behaviour_state()
		print("test !!!")
		
