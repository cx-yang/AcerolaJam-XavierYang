extends Node

var easy_words = [
	"add up","brown dog","cow tools","doing","funny","good job","hat","instant","jump","kitty","love","music","nice crock","ocelot",
	"party","quiz","red","tuba","umbrella","victory","wumbo","year","zoo","above you","birthday","cotton",
	"drink water","eyes","flower","giraffe","honey","idea","jump","kncok knock","learn","mail time",
	"nutella","outside pool","power stance","quesadilla", "reptile", "turtle power", "util","visit friends",
	"wack","","","","","",]

var happy_words = [
	"achievement","bubbles","comical","definite",
	"empowered","favorite","gnarly","hospitable",
	"ideal","joysome","knockout","luminous",
	"majestic","neighborly","organize","phenomenal",
	"quirk","recess","tubular",
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

#String is the prompt. Number after is the array position to make the event handler go to
var events = [
	["do you like fruit?", 1],
	["apple", 4, "orange", 5, "pear", 6],
	["bottom", 0],
	["jeans", 0],
	["you choose apple",  0],
	["you choose orange", 0],
	["you choose pear", 0],
]

func get_happy_prompt() -> String:
	var word_index = randi() % happy_words.size()
	var special_index = randi() % special_characters.size()
	
	var word = happy_words[word_index]
	var special_character = special_characters[special_index]
	
	return word + special_character

func get_salamander_prompt() -> String:
	return "salamander"

#check if event_size > 1 to differentiate spawning the prompt or options
func get_event_size(event_number: int) -> int:
	return events[event_number].size()

func get_event_prompt(event_number: int, position: int) -> String:
	return events[event_number][position]

func get_next_event_number(event_number:int, position: int) -> int:
	return events[event_number][position+1]

