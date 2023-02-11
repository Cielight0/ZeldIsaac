extends Node2D

@onready var coin_scene = preload("res://Scenes/InteractiveObjects/Coin/coin.tscn")

func _ready()->void:
	EVENTS.spawn_coin.connect(_on_EVENTS_spawn_coin)

func _spawn_coin(pos: Vector2)->void:
	var coin = coin_scene.instantiate()
	coin.set_position(pos)
	owner.add_child(coin)

func _on_EVENTS_spawn_coin(pos:Vector2):
	_spawn_coin(pos)
