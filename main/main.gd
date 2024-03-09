extends Node2D

@onready var enemy_container = $EnemyContainer
@onready var event_spawner = $EventSpawner
@onready var spawn_container = $SpawnContainer
@onready var spawn_timer = $SpawnTimer
@onready var difficulty_timer = $DifficultyTimer

@onready var game_over_screen = $MenuUI/GOMC
@onready var menu_ui = $MenuUI

var active_enemy: CharacterBody2D = null
var current_letter_index: int = -1
var last_spawn_number: int = 0

var difficulty: int = 0
var score: int = 0
var life_points: int = 3

var current_container_type = "enemy"
var event_number: int = 0
var prompt_and_answer_count: int = 0 #keeps track of the prompts and answers
var can_spawn_event: bool = false
var loop_count: int = 0 #when this gets to a certain number after the event spawn, change the prompt in the spawner

var enemy = preload("res://enemy/enemy_base.tscn")
var easy_happy_enemy = preload("res://enemy/easy_happy_enemy.tscn")
var salamander = preload("res://enemy/salamander_enemy.tscn")
var event_enemy = preload("res://enemy/event_enemy.tscn")

func _ready() -> void:
	SignalManager.start_game.connect(start_game)
	start_game()

func _process(delta):
	if can_spawn_event and enemy_container.get_child_count() == 0:
		current_container_type = "event"
		can_spawn_event = false
		spawn_event_enemies()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_pressed():
		var typed_event = event as InputEventKey
		var key_typed = event.as_text().to_lower() #PackedByteArray([typed_event.unicode]).get_string_from_utf8()
		#print("Key: ", key_typed)
		
		if active_enemy == null: #and if current_container_type == "enemy"
			find_new_active_enemy(key_typed, current_container_type)
		elif key_typed == "shift":
			return
		else:
			var prompt = active_enemy.get_prompt() #use active_enemy to set up the next event to display
			var next_character = prompt.substr(current_letter_index, 1)
			if key_typed == next_character or (next_character == " " and key_typed == "space") or (next_character == "!" and key_typed == "shift+1") or (next_character == "?" and key_typed == "shift+slash"):
				print("successfully typed: ", key_typed)
				current_letter_index += 1
				active_enemy.set_next_character(current_letter_index)
				
				if current_letter_index == prompt.length():
					
					if current_container_type == "event":
						event_number = active_enemy.get_next_event_number()
						for enemy in event_spawner.get_children():
							score += enemy.get_prompt().length() * 80
							enemy.queue_free()
						SignalManager.current_score.emit(score)
						current_letter_index = -1
						active_enemy.queue_free()
						active_enemy = null
						
						#restart game loop
						if prompt_and_answer_count >= 1:
							prompt_and_answer_count = 0
							difficulty_timer.start()
							difficulty = 2
							SignalManager.current_difficulty.emit(difficulty)
							spawn_timer.start()
							current_container_type = "enemy"
						else:
							prompt_and_answer_count += 1
							spawn_event_enemies()
						return
					
					if prompt == "salamander":
						for enemy in enemy_container.get_children():
							score += enemy.get_prompt().length() * 80
							enemy.queue_free()
						SignalManager.current_score.emit(score)
						current_letter_index = -1
						active_enemy.queue_free()
						active_enemy = null
						return
					
					print("done")
					score = prompt.length() * 120
					SignalManager.current_score.emit(score)
					current_letter_index = -1
					active_enemy.queue_free()
					active_enemy = null
			else:
				print("incorrectly typed: %s instead of %s " %[key_typed, next_character])

#change to take an enemy from either container from parameter call
func find_new_active_enemy(typed_character: String, container_type: String):
	if container_type == "enemy":
		for enemy in enemy_container.get_children():
			var prompt = enemy.get_prompt()
			var next_character = prompt.substr(0,1)
			print("typed character: ", typed_character)
			
			if next_character == typed_character:
				print("found new enemy that starts with %s " % next_character)
				active_enemy = enemy
				current_letter_index = 1
				active_enemy.set_next_character(current_letter_index)
				return
	else:
		for enemy in event_spawner.get_children():
			var prompt = enemy.get_prompt()
			var next_character = prompt.substr(0,1)
			print("typed character: ", typed_character)
			
			if next_character == typed_character:
				print("found new enemy that starts with %s " % next_character)
				active_enemy = enemy
				current_letter_index = 1
				active_enemy.set_next_character(current_letter_index)
				return

func _on_spawn_timer_timeout():
	spawn_enemy()

func spawn_enemy() -> void:
	var enemy_instance = easy_happy_enemy.instantiate()
	var spawns = spawn_container.get_children()
	var index = randi() % spawns.size()
	
	enemy_instance.global_position = spawns[index].global_position
	enemy_container.add_child(enemy_instance)
	enemy_instance.set_difficulty(difficulty)
	
	#enemy_instance.set_prompt(prompt_type)

func spawn_salamander() -> void:
	var enemy_instance = salamander.instantiate()
	var spawns = spawn_container.get_children()
	var index = randi() % spawns.size()
	
	enemy_instance.global_position = spawns[index].global_position
	enemy_container.add_child(enemy_instance)
	enemy_instance.set_difficulty(difficulty)

func spawn_event_enemies() -> void:
	var current_event_number = event_number
	SignalManager.current_difficulty.emit(current_event_number)
	
	if PromptList.get_event_size(current_event_number) > 2:
		var enemy_instance1 = event_enemy.instantiate()
		var enemy_instance2 = event_enemy.instantiate()
		var enemy_instance3 = event_enemy.instantiate()
		
		var spawns = spawn_container.get_children()
		enemy_instance1.global_position = spawns[1].global_position
		enemy_instance2.global_position = spawns[4].global_position
		enemy_instance3.global_position = spawns[7].global_position
		
		event_spawner.add_child(enemy_instance1)
		event_spawner.add_child(enemy_instance2)
		event_spawner.add_child(enemy_instance3)
		
		enemy_instance1.set_event_prompt(current_event_number,0)
		enemy_instance2.set_event_prompt(current_event_number,2)
		enemy_instance3.set_event_prompt(current_event_number,4)
	else:
		var enemy_instance1 = event_enemy.instantiate()
		var spawns = spawn_container.get_children()
		enemy_instance1.global_position = spawns[4].global_position
		event_spawner.add_child(enemy_instance1)
		enemy_instance1.set_event_prompt(current_event_number,0)

func _on_difficulty_timer_timeout():
	if difficulty >= 3:
		difficulty_timer.stop()
		difficulty = 3
		
		spawn_timer.stop()
		can_spawn_event = true
		
		return
	
	if difficulty % 5 == 0:
		spawn_salamander()
	
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
	
	spawn_timer.start()
	difficulty_timer.start()

#call this when game over
func game_over() -> void:
	active_enemy = null
	spawn_timer.stop()
	difficulty_timer.stop()
	SignalManager.game_over.emit()
	
	for enemy in enemy_container.get_children():
		enemy.queue_free()

#when the enemy gets off screen
func _on_area_2d_body_entered(body):
	life_points -= 1
	menu_ui.set_life_points(life_points)
	print(life_points)
	if active_enemy != null:
		if active_enemy.get_prompt() == body.get_prompt():
			active_enemy.queue_free()
			active_enemy = null
	else:
		body.queue_free()
	
	if life_points <= 0:
		game_over()
		menu_ui.game_over()

func _on_prompt_move_area_body_entered(body):
	body.move_prompt_position()
