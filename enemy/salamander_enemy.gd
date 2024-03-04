extends enemy_base

func _ready():
	SignalManager.difficulty_increased.connect(handle_difficulty_increase)
	SignalManager.move_prompt_position.connect(move_prompt_position)
	set_salamander_prompt()

func _physics_process(delta: float) -> void:
	if !is_on_screen:
		global_position.y += initial_speed
	else:
		global_position.y += speed
	
func set_salamander_prompt() -> void:
	prompt_text = PromptList.get_salamander_prompt()
	prompt.parse_bbcode(set_center_tags(prompt_text))
