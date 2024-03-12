extends Node

var salamnder_theme = load("res://assets/sfx/SalamanderTheme.wav")
var after = load("res://assets/sfx/after.wav")
var game_over_theme = load("res://assets/sfx/SalamanderGameOver.wav")

var high_score: int = 0

@onready var music = $Music

func play_salamander_theme() -> void:
	music.stream = salamnder_theme
	music.play()

func play_after() -> void:
	music.stream = after
	music.play()

func play_game_over_theme() -> void:
	music.stream = game_over_theme
	music.play()

func get_high_score() -> int:
	return high_score
