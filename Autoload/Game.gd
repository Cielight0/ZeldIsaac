extends Node

var nb_coins : int = 0

func set_nb_coins(value: int):
	if value != nb_coins:
		nb_coins=value
		EVENTS.emit_signal("nb_coins_changed", nb_coins)

func _ready() -> void:
	EVENTS.coin_collected.connect(_on_EVENTS_coin_collected)

func _on_EVENTS_coin_collected():
	set_nb_coins(nb_coins+1)
