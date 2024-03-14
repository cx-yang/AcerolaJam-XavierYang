extends enemy

func _ready():
	SignalManager.difficulty_increased.connect(handle_difficulty_increase)
	SignalManager.move_prompt_position.connect(move_prompt_position)
	set_random_salamander()
	set_happy_prompt()

func _physics_process(delta: float) -> void:
	if !is_on_screen:
		global_position.y += initial_speed + 1
	else:
		global_position.y += speed

func set_gibberish_prompt() -> void:
	prompt_text = PromptList.get_gibberish_prompt()
	prompt.parse_bbcode(set_center_tags(prompt_text))
