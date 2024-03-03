extends Node

var happy_words = [
	"achievement",
	"bubbles",
	"comical",
	"definite",
	"empowered",
	"favorite",
	"gnarly",
	"hospitable",
	"ideal",
	"joysome",
	"knockout",
	"luminous",
	"majestic",
	"neighborly",
	"organize",
	"phenomenal",
	"quirk",
	"recess",
	"savvy",
	"tubular",
	"urbane",
	"vivacious",
	"wizard",
	"xenodochial",
	"yay",
	"zealous"
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

func get_happy_prompt() -> String:
	var word_index = randi() % happy_words.size()
	var special_index = randi() % special_characters.size()
	
	var word = happy_words[word_index]
	var special_character = special_characters[special_index]
	
	return word + special_character


