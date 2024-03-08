extends Node

var easy_words = [
	"add up","brown dog","cow tools","","","","","","","","","","","",
	"","","","","","","","","","","","","","",
	"","","","","","","","","","","","","","",]

var happy_words = [
	"achievement","bubbles","comical","definite",
	"empowered","favorite","gnarly","hospitable",
	"ideal","joysome","knockout","luminous",
	"majestic","neighborly","organize","phenomenal",
	"quirk","recess","savvy","tubular",
	"urbane","vivacious","wizard","xenodochial",
	"yay","zealous"
	]

var special_characters = [
	"",
	"",
	"",
	"!",
	"?"
]

var dialogue1 =[
	"help me"
]

var events = [
	["apple"],
	["bottom"],
	["jeans"]
]

func get_happy_prompt() -> String:
	var word_index = randi() % happy_words.size()
	var special_index = randi() % special_characters.size()
	
	var word = happy_words[word_index]
	var special_character = special_characters[special_index]
	
	return word + special_character

func get_salamander_prompt() -> String:
	return "salamander"

func get_event_prompt(event_number: int, position: int) -> String:
	return events[event_number][position]
