extends enemy_base

func _ready():
	SignalManager.difficulty_increased.connect(handle_difficulty_increase)
	SignalManager.move_prompt_position.connect(move_prompt_position)
	set_happy_prompt()

func _physics_process(delta: float) -> void:
	if !is_on_screen:
		global_position.y += initial_speed
	else:
		global_position.y += speed
	
