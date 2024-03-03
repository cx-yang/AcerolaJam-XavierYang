extends enemy_base

func _ready():
	SignalManager.difficulty_increased.connect(handle_difficulty_increase)
	set_happy_prompt()

func _physics_process(delta: float) -> void:
	if !is_on_screen:
		global_position.y += initial_speed
	else:
		global_position.y += speed
