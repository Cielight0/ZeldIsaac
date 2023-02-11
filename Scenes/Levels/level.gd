extends Node2D

@onready var music = $LevelMusic


# Called when the node enters the scene tree for the first time.
func _ready():
	music.play()
