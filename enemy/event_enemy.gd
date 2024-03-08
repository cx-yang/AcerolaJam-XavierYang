extends enemy_base

@export var event_number: int = 0
@export var option_number: int = 0

func _ready():
	#SignalManager.difficulty_increased.connect(handle_difficulty_increase)
	SignalManager.move_prompt_position.connect(move_prompt_position)
	set_random_salamander()
	#set_event_prompt()

func _physics_process(delta: float) -> void:
	if !is_on_screen:
		global_position.y += initial_speed
	else:
		global_position.y += speed

func set_option_number(option: int) -> void:
	option_number = option

func get_option_number() -> int:
	return option_number

func set_event_prompt(event_number: int, option_number: int) -> void:
	prompt_text = PromptList.get_event_prompt(event_number, option_number)
	prompt.parse_bbcode(set_center_tags(prompt_text))
