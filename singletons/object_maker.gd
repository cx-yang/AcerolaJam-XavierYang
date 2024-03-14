extends Node

var OBJECTS = {
	ENEMY = load("res://enemy/easy_happy_enemy.tscn"),
	SALAMANDER = load("res://enemy/salamander_enemy.tscn"),
	EVENT = load("res://enemy/event_enemy.tscn"),
	EXPLOSION = load("res://enemy/enemy_explosion.tscn")
}

const enemy_container: String = "EnemyContainer"
const event_container: String = "EventSpawner"
const spawn_container: String = "SpawnContainer"

#container types are: EventSpawner, EnemyContainer
func add_child_deferred(child_to_add, container_type: String, current_event_number: int = 0, enemy_position: int = 0) -> void:
	get_tree().root.get_node("Main").get_node(container_type).add_child(child_to_add)
	
	if container_type == event_container:
		child_to_add.set_event_prompt(current_event_number, enemy_position)
	
	if current_event_number >= 24 and container_type == enemy_container:
		child_to_add.set_gibberish_prompt()

func call_add_child(child_to_add, container_type: String, current_event_number: int = 0, enemy_position: int = 0) -> void:
	call_deferred("add_child_deferred", child_to_add, container_type, current_event_number, enemy_position)

func spawn_enemy(event_number: int, difficulty: int) -> void:
	var enemy_instance = OBJECTS.ENEMY.instantiate()
	enemy_instance.global_position = get_random_position()
	enemy_instance.set_difficulty(difficulty)

	call_add_child(enemy_instance, enemy_container, event_number)

func spawn_salamander() -> void:
	var enemy_instance = OBJECTS.SALAMANDER.instantiate()
	enemy_instance.global_position = get_random_position()
	call_add_child(enemy_instance, enemy_container)

func spawn_event_enemies(event_number: int) -> void:
	var current_event_number = event_number
	SignalManager.current_difficulty.emit(current_event_number * 13 + 13)
	
	if PromptList.get_event_size(current_event_number) > 2:
		var enemy_position: int = 0
		for n in 3:
			var enemy_instance = OBJECTS.EVENT.instantiate()
			enemy_instance.global_position = get_random_position()
			
			match n:
				0:
					enemy_instance.global_position = get_random_position(90, 340)
				1:
					enemy_instance.global_position = get_random_position(423, 673)
				2:
					enemy_instance.global_position = get_random_position(756, 1006)
			call_add_child(enemy_instance, event_container, current_event_number, enemy_position)
			#enemy_instance.set_event_prompt(current_event_number, enemy_position)
			enemy_position += 2
			
	else:
		var enemy_instance = OBJECTS.EVENT.instantiate()
		enemy_instance.global_position = get_random_position()
		call_add_child(enemy_instance, event_container, current_event_number)
		#enemy_instance.set_event_prompt(current_event_number,0)

func create_explosion(start_posititon: Vector2) -> void:
	var new_explosion = OBJECTS.EXPLOSION.instantiate()
	new_explosion.global_position = start_posititon
	call_add_child(new_explosion, spawn_container)

func get_random_position(start_x: float = 90.0, end_x: float = 1200.0, start_y: float = -50.0, end_y: float = -75.0) -> Vector2:
	return Vector2(randf_range(start_x, end_x), randf_range(start_y, end_y))
