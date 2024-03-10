extends Node2D

@onready var enemy_container = $EnemyContainer
@onready var event_spawner = $EventSpawner
@onready var spawn_container = $SpawnContainer
@onready var spawn_timer = $SpawnTimer
@onready var difficulty_timer = $DifficultyTimer
@onready var salamander_timer = $SalamanderTimer

@onready var game_over_screen = $MenuUI/GOMC
@onready var menu_ui = $MenuUI
@onready var typing_sound = $TypingSound

var active_enemy: CharacterBody2D = null
var current_letter_index: int = -1
var last_spawn_number: int = 0

var difficulty: int = 0
var score: int = 0
var life_points: int = 3
var is_game_over: bool = false

var current_container_type = "enemy"
var event_number: int = 0
var prompt_and_answer_count: int = 0 #keeps track of the prompts and answers
var can_spawn_event: bool = false
var loop_count: int = 0 #when this gets to a certain number after the event spawn, change the prompt in the spawner

var easy_happy_enemy: PackedScene = preload("res://enemy/easy_happy_enemy.tscn")
var salamander: PackedScene = preload("res://enemy/salamander_enemy.tscn")
var event_enemy: PackedScene = preload("res://enemy/event_enemy.tscn")
var explosion: PackedScene = preload("res://enemy/enemy_explosion.tscn")

func _ready() -> void:
	SignalManager.start_game.connect(start_game)

func _process(delta):
	if can_spawn_event and enemy_container.get_child_count() == 0 and event_number != 24 and !is_game_over:
		current_container_type = "event"
		can_spawn_event = false
		spawn_event_enemies()
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_pressed():
		var typed_event = event as InputEventKey
		var key_typed = event.as_text().to_lower() #PackedByteArray([typed_event.unicode]).get_string_from_utf8()
		#print("Key: ", key_typed)
		if active_enemy == null:
			find_new_active_enemy(key_typed, current_container_type)
		elif key_typed == "shift":
			return
		else:
			var prompt = active_enemy.get_prompt()
			var next_character = prompt.substr(current_letter_index, 1)
			if key_typed == next_character or (next_character == " " and key_typed == "space") or (next_character == "!" and key_typed == "shift+1") or (next_character == "?" and key_typed == "shift+slash"):
				print("successfully typed: ", key_typed)
				current_letter_index += 1
				active_enemy.set_next_character(current_letter_index)
				correct_key_pressed()
				if current_letter_index == prompt.length():
					if current_container_type == "event":
						event_number = active_enemy.get_next_event_number()
						continer_cleaning(event_spawner)
						reset_properties()
						#restart game loop
						if prompt_and_answer_count >= 1:
							prompt_and_answer_count = 0
							start_timers()
							difficulty = 2
							SignalManager.current_difficulty.emit(difficulty)
							current_container_type = "enemy"
						else:
							prompt_and_answer_count += 1
							spawn_event_enemies()
						return
					if prompt == "salamander":
						continer_cleaning(enemy_container)
						return
					score = prompt.length() * 120
					reset_properties()
			else:
				print("incorrectly typed: %s instead of %s " %[key_typed, next_character])
				#play bad noise

#change to take an enemy from either container from parameter call
func find_new_active_enemy(typed_character: String, container_type: String):
	if container_type == "enemy":
		find_new_enemy_in_container(typed_character, enemy_container)
	else:
		find_new_enemy_in_container(typed_character, event_spawner)

func find_new_enemy_in_container(typed_character: String, continer_type: Node2D) -> void:
	for enemy in continer_type.get_children():
		var prompt = enemy.get_prompt()
		var next_character = prompt.substr(0,1)
		print("typed character: ", typed_character)
		
		if next_character == typed_character:
			correct_key_pressed()
			print("found new enemy that starts with %s " % next_character)
			active_enemy = enemy
			current_letter_index = 1
			active_enemy.set_next_character(current_letter_index)
			return

func _on_spawn_timer_timeout():
	spawn_enemy()

func spawn_enemy() -> void:
	var enemy_instance = easy_happy_enemy.instantiate()
	spawn_enemy_type(enemy_instance, enemy_container)
	
	if event_number >= 24:
		enemy_instance.set_gibberish_prompt()

func spawn_salamander() -> void:
	var enemy_instance = salamander.instantiate()
	spawn_enemy_type(enemy_instance, enemy_container)

func spawn_enemy_type(enemy_instance: enemy_base, container_type: Node2D, can_set_difficulty: bool = true)-> void:
	var spawns = spawn_container.get_children()
	var index = randi() % spawns.size()
	
	enemy_instance.global_position = spawns[index].global_position
	container_type.add_child(enemy_instance)
	if can_set_difficulty:
		enemy_instance.set_difficulty(difficulty)

func spawn_event_enemies() -> void:
	var current_event_number = event_number
	SignalManager.current_difficulty.emit(current_event_number * 13)
	
	if PromptList.get_event_size(current_event_number) > 2:
		var index: int = randi() % 6
		var enemy_position: int = 0
		for n in 3:
			var enemy_instance = event_enemy.instantiate()
			var spawns = spawn_container.get_children()
			enemy_instance.global_position = spawns[index].global_position
			index += 6
			event_spawner.add_child(enemy_instance)
			enemy_instance.set_event_prompt(current_event_number, enemy_position)
			enemy_position += 2
	else:
		var enemy_instance = event_enemy.instantiate()
		spawn_enemy_type(enemy_instance, event_spawner, false)
		enemy_instance.set_event_prompt(current_event_number,0)

func _on_difficulty_timer_timeout():
	if difficulty >= 3 and event_number != 24:
		stop_timers()
		difficulty = 3
		can_spawn_event = true
		return
	
	difficulty += 1
	SignalManager.difficulty_increased.emit(difficulty)
	SignalManager.current_difficulty.emit(difficulty)
	print("difficulty increased to: ", difficulty)
	var new_wait_time = spawn_timer.wait_time - 0.2
	spawn_timer.wait_time = clamp(new_wait_time, 1, spawn_timer.wait_time)

func start_game() -> void:
	current_letter_index = -1
	difficulty = 0
	score = 0
	event_number = 0
	life_points = 3
	spawn_timer.wait_time = 4
	is_game_over = false
	start_timers()

func game_over() -> void:
	active_enemy = null
	stop_timers()
	is_game_over = true
	SignalManager.game_over.emit()
	continer_cleaning(enemy_container)
	continer_cleaning(event_spawner)

#when the enemy gets off screen
func _on_area_2d_body_entered(body):
	life_points -= 1
	menu_ui.set_life_points(life_points)
	print(life_points)
	if active_enemy != null:
		if active_enemy.get_prompt() == body.get_prompt():
			create_explosion(body.global_position)
			active_enemy.queue_free()
			active_enemy = null
	else:
		body.queue_free()
	
	if life_points <= 0:
		game_over()
		menu_ui.game_over()

func _on_prompt_move_area_body_entered(body):
	body.move_prompt_position()

func _on_salamander_timer_timeout():
	spawn_salamander()

func correct_key_pressed() -> void:
	typing_sound.play()

func reset_properties() -> void:
	SignalManager.current_score.emit(score)
	current_letter_index = -1
	create_explosion(active_enemy.global_position)
	active_enemy.queue_free()
	active_enemy = null

func continer_cleaning(container_type: Node2D) -> void:
	for enemy in container_type.get_children():
		score += enemy.get_prompt().length() * 80
		create_explosion(enemy.global_position)
		enemy.queue_free()

func start_timers() -> void:
	spawn_timer.start()
	difficulty_timer.start()
	salamander_timer.start()

func stop_timers() -> void:
	spawn_timer.stop()
	difficulty_timer.stop()
	salamander_timer.stop()

func create_explosion(start_posititon: Vector2) -> void:
	var new_explosion = explosion.instantiate()
	new_explosion.global_position = start_posititon
	spawn_container.add_child(new_explosion)
