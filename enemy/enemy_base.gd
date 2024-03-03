extends CharacterBody2D

class_name enemy_base

@export var blue = Color("#4682b4")
@export var green = Color("#639765")
@export var red = Color("#a65455")

@export var speed: float = 0.2

@onready var prompt = $prompt
@onready var prompt_text = prompt.text

@onready var action_timer = $ActionTimer

var initial_speed: float = 1
var is_on_screen: bool = false

func _ready():
	SignalManager.difficulty_increased.connect(handle_difficulty_increase)
	set_happy_prompt()

func _physics_process(delta: float) -> void:
	if !is_on_screen:
		global_position.y += initial_speed
	else:
		global_position.y += speed

func get_prompt() -> String:
	return prompt_text

func set_next_character(next_character_index: int) -> void:
	var blue_text = get_bbcode_color_tag(blue) +  prompt_text.substr(0, next_character_index) 
	var green_text = get_bbcode_color_tag(green) +  prompt_text.substr(next_character_index, 1)
	var red_text = ""
		
	if next_character_index != prompt.text.length():
		red_text = get_bbcode_color_tag(red) +  prompt_text.substr(next_character_index + 1, prompt_text.length())
	
	var parse_bb_code_colors = str("[center]%s%s%s" %[blue_text, green_text, red_text])
	prompt.parse_bbcode(parse_bb_code_colors)

func  get_bbcode_color_tag(color: Color) -> String:
	return "[color=#" + color.to_html(false) + "]"

func get_bbcode_end_color_tag() -> String:
	return "[/color]"

func set_center_tags(string_to_center: String) -> String:
	return "[center]%s" %string_to_center

func set_difficulty(difficulty: int) -> void:
	handle_difficulty_increase(difficulty)

func handle_difficulty_increase(difficulty: int) -> void:
	var new_speed = speed + (0.125 * difficulty)
	speed = clamp(new_speed, speed, 3)

func set_happy_prompt() -> void:
	prompt_text = PromptList.get_happy_prompt()
	prompt.parse_bbcode(set_center_tags(prompt_text))

func _on_action_timer_timeout():
	initial_speed = 0.2
	is_on_screen = true
