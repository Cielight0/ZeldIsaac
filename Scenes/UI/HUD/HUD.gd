extends TextureRect
@onready var coin_counter_label = $CoinCounter

func _ready()->void:
	EVENTS.nb_coins_changed.connect(_on_EVENTS_nb_coins_changed)

func _on_EVENTS_nb_coins_changed(nb_coins:int)-> void:
	coin_counter_label.set_text(str(nb_coins))
