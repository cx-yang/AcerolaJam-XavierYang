extends Node2D

@onready var enemy_container = $EnemyContainer
@onready var enemy_base = $EnemyBase
@onready var spawn_container = $SpawnContainer
@onready var spawn_timer = $SpawnTimer

var active_enemy: CharacterBody2D = null
var current_letter_index: int = -1
var last_spawn_number: int = 0

var enemy = preload("res://enemy/enemy_base.tscn")

func _ready() -> void:
	randomize()
	spawn_enemy()
	
	spawn_timer.start()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_pressed():
		var typed_event = event as InputEventKey
		var key_typed = event.as_text().to_lower() #PackedByteArray([typed_event.unicode]).get_string_from_utf8()
		#print("Key: ", key_typed)
		
		if active_enemy == null:
			find_new_active_enemy(key_typed)
		elif key_typed == "shift":
			return
		else:
			var prompt = active_enemy.get_prompt()
			var next_character = prompt.substr(current_letter_index, 1)
			if key_typed == next_character or (next_character == " " and key_typed == "space") or (next_character == "!" and key_typed == "shift+1") or (next_character == "?" and key_typed == "shift+slash"):
				print("successfully typed: ", key_typed)
				current_letter_index += 1
				active_enemy.set_next_character(current_letter_index)
				if current_letter_index == prompt.length():
					print("done")
					current_letter_index = -1
					active_enemy.queue_free()
					active_enemy = null
			else:
				print("incorrectly typed: %s instead of %s " %[key_typed, next_character])

func find_new_active_enemy(typed_character: String):
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

func _on_spawn_timer_timeout():
	spawn_enemy()

func spawn_enemy() -> void:
	var enemy_instance = enemy.instantiate()
	var spawns = spawn_container.get_children()
	
	var index = randi() % spawns.size()
	last_spawn_number = index
	
	enemy_container.add_child(enemy_instance)
	enemy_instance.global_position = spawns[index].global_position

