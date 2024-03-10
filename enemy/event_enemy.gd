extends enemy_base

@export var event_number: int = 0
@export var option_number: int = 0

var next_event_number: int = 0

func _ready():
	SignalManager.move_prompt_position.connect(move_prompt_position)
	set_random_salamander()

func _physics_process(delta: float) -> void:
	if !is_on_screen:
		global_position.y += initial_speed
	else:
		global_position.y += speed

func set_option_number(option: int) -> void:
	option_number = option

func get_option_number() -> int:
	return option_number

func get_next_event_number() -> int:
	return next_event_number

func set_event_prompt(event_number: int, option_number: int) -> void:
	next_event_number = PromptList.get_next_event_number(event_number, option_number)
	prompt_text = PromptList.get_event_prompt(event_number, option_number)
	prompt.parse_bbcode(set_center_tags(prompt_text))

