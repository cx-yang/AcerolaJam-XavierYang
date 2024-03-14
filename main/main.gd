extends Node2D

@onready var enemy_container = $EnemyContainer
@onready var event_spawner = $EventSpawner
@onready var spawn_container = $SpawnContainer
@onready var spawn_timer = $SpawnTimer
@onready var difficulty_timer = $DifficultyTimer
@onready var salamander_timer = $SalamanderTimer

@onready var game_over_screen = $MenuUI/GOMC
@onready var menu_ui = $MenuUI
@onready var sfx = $sfx

var active_enemy: CharacterBody2D = null
var current_letter_index: int = -1
var last_spawn_number: int = 0

var difficulty: int = 0
var score: int = 0
var life_points: int = 3

var is_game_over: bool = false
var gibberish_active: bool = false
var playing_after_song: bool = false
var can_spawn_event: bool = false

var current_container_type = "enemy"
var event_number: int = 0
var prompt_and_answer_count: int = 0 #keeps track of the prompts and answers
var loop_count: int = 0 #when this gets to a certain number after the event spawn, change the prompt in the spawner

func _ready() -> void:
	SignalManager.start_game.connect(start_game)

func _process(delta):
	if can_spawn_event and enemy_container.get_child_count() == 0 and event_number != 24 and !is_game_over:
		current_container_type = "event"
		can_spawn_event = false
		ObjectMaker.spawn_event_enemies(event_number)
	
	if event_number >= 24 and !playing_after_song:
		MusicController.play_after()
		salamander_timer.stop()
		playing_after_song = true
		difficulty_timer.wait_time = 10

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_pressed():
		var typed_event = event as InputEventKey
		var key_typed = event.as_text().to_lower()
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
				if current_letter_index < prompt.length():
					SoundController.play_clip(sfx, SoundController.SOUND_CORRECT)
				if current_letter_index == prompt.length():
					if current_container_type == "event":
						event_number = active_enemy.get_next_event_number()
						continer_cleaning(event_spawner)
						reset_properties()
						SoundController.play_clip(sfx, SoundController.SOUND_CORRECT)
						#restart game loop
						if prompt_and_answer_count >= 1:
							
							if prompt == "break it":
								SoundController.play_clip(sfx, SoundController.SOUND_BONE)
							if prompt == "and cut it" or prompt == "then cut it more" or prompt == "until it is disconnected":
								SoundController.play_clip(sfx, SoundController.SOUND_CUT)
							
							prompt_and_answer_count = 0
							start_timers()
							difficulty = 2
							SignalManager.current_difficulty.emit(loop_count)
							current_container_type = "enemy"
						else:
							prompt_and_answer_count += 1
							ObjectMaker.spawn_event_enemies(event_number)
						return
					if prompt == "salamander":
						continer_cleaning(enemy_container)
						SoundController.play_clip(sfx, SoundController.SOUND_SALAMANDER)
						return
					score = prompt.length() * 30
					reset_properties()
					SoundController.play_clip(sfx, SoundController.SOUND_CORRECT)
			else:
				#print("incorrectly typed: %s instead of %s " %[key_typed, next_character])
				SignalManager.current_score.emit(-300)

func find_new_active_enemy(typed_character: String, container_type: String):
	match container_type:
		"enemy":
			find_new_enemy_in_container(typed_character, enemy_container)
		_:
			find_new_enemy_in_container(typed_character, event_spawner)

func find_new_enemy_in_container(typed_character: String, continer_type: Node2D) -> void:
	for enemy in continer_type.get_children():
		var prompt = enemy.get_prompt()
		var next_character = prompt.substr(0,1)
		print("typed character: ", typed_character)
		
		if next_character == typed_character:
			SoundController.play_clip(sfx, SoundController.SOUND_CORRECT)
			print("found new enemy that starts with %s " % next_character)
			active_enemy = enemy
			current_letter_index = 1
			active_enemy.set_next_character(current_letter_index)
			return

func _on_spawn_timer_timeout():
	ObjectMaker.spawn_enemy(event_number, difficulty)

func _on_difficulty_timer_timeout():
	loop_count += 1
	SignalManager.current_difficulty.emit(loop_count)
	if difficulty >= 3 and event_number != 24:
		stop_timers()
		difficulty = 3
		can_spawn_event = true
		return
	difficulty += 1
	SignalManager.difficulty_increased.emit(difficulty)
	print("difficulty increased to: ", difficulty)
	var new_wait_time = spawn_timer.wait_time - 0.15
	spawn_timer.wait_time = clamp(new_wait_time, 1, spawn_timer.wait_time)

func start_game() -> void:
	if is_game_over:
		MusicController.play_salamander_theme()
	current_letter_index = -1
	difficulty = 0
	score = 0
	event_number = 0
	life_points = 3
	spawn_timer.wait_time = 4
	is_game_over = false
	start_timers()

func game_over() -> void:
	MusicController.play_game_over_theme()
	active_enemy = null
	stop_timers()
	event_number = 0
	can_spawn_event = false
	is_game_over = true
	SignalManager.game_over.emit()
	continer_cleaning(enemy_container,false)
	continer_cleaning(event_spawner, false)

#when the enemy gets off screen
func _on_area_2d_body_entered(body):
	SoundController.play_clip(sfx, SoundController.SOUND_MISS)
	life_points -= 1
	menu_ui.set_life_points(life_points)
	print(life_points)
	if active_enemy != null:
		if active_enemy.get_prompt() == body.get_prompt():
			ObjectMaker.create_explosion(body.global_position)
			active_enemy.poof_me()
			active_enemy = null
	else:
		body.poof_me()
	
	if life_points <= 0:
		game_over()
		menu_ui.game_over()

func _on_prompt_move_area_body_entered(body):
	body.move_prompt_position()

func _on_salamander_timer_timeout():
	if event_number % 4 == 0:
		ObjectMaker.spawn_salamander()

func reset_properties() -> void:
	SignalManager.current_score.emit(score)
	current_letter_index = -1
	ObjectMaker.create_explosion(active_enemy.global_position)
	active_enemy.poof_me()
	active_enemy = null

func continer_cleaning(container_type: Node2D, is_game_active: bool = true) -> void:
	for enemy in container_type.get_children():
		score += enemy.get_prompt().length() * 80
		ObjectMaker.create_explosion(enemy.global_position)
		enemy.poof_me()
	if is_game_active:
		SignalManager.current_score.emit(score)

func start_timers() -> void:
	spawn_timer.start()
	difficulty_timer.start()
	salamander_timer.start()

func stop_timers() -> void:
	spawn_timer.stop()
	difficulty_timer.stop()
	salamander_timer.stop()
