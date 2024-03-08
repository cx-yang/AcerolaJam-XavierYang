extends ParallaxBackground

func _ready():
	SignalManager.game_over.connect(game_over)
	SignalManager.start_game.connect(start_game)

func _process(delta):
	scroll_offset.y -= 100 * delta

func game_over() -> void:
	set_process(false)

func start_game() -> void:
	set_process(true)
