extends Node2D

@onready var coin_scene = preload("res://Scenes/InteractiveObjects/Coin/coin.tscn")

func _ready()->void:
	EVENTS.spawn_coin.connect(_on_EVENTS_spawn_coin)

func _spawn_coin(pos: Vector2, nb_coin : int)->void:
	for i in range(nb_coin):
		var coin = coin_scene.instantiate()
		coin.set_position(pos)
		owner.add_child(coin)

func _on_EVENTS_spawn_coin(pos:Vector2):
	var nb_coin = randi_range(1, 5)
	_spawn_coin(pos,nb_coin)
