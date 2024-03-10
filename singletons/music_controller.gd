extends Node

var salamnder_theme = load("res://assets/sfx/SalamanderTheme.wav")

@onready var music = $Music

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_salamander_theme() -> void:
	music.stream = salamnder_theme
	music.play()

func stop_music() -> void:
	music.stop()

func lower_music() -> void:
	music.volume_db = -9

func lowest_music() -> void:
	music.volume_db = -11
