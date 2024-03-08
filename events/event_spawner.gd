extends Node2D

"""
@onready var event_enemy_1 = $EventEnemy1
@onready var event_enemy_2 = $EventEnemy2
@onready var event_enemy_3 = $EventEnemy3
"""

func _ready():
	pass

#event number is equal to difficulty number
func get_event_prompt(event_number: int) -> void:
	#set_event_options(event_number)
	pass

"""
func set_event_options(event_number: int) -> void:
	event_enemy_1.set_event_option(event_number, 0)
	event_enemy_2.set_event_option(event_number, 1)
	event_enemy_3.set_event_option(event_number, 2)
"""
