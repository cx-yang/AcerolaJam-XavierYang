extends Node

var happy_words = [
	"achievement","bubbles","comical","definite","empowered","favorite","gnarly","hospitable",
	"ideal","joysome","key","luminous","majestic","neighborly","organize","phenomenal",
	"quirk","recess","tubular","urbane","vivacious","wizard","xenodochial","yay","zealous",
	"add up","brown dog","cow tools","doing","funny","good job","hat","instant","jump","kitty","love","music","nice crock","ocelot",
	"party","quiz","red","tuba","umbrella","victory","wumbo","year","zoo","above you","birthday","cotton",
	"drink water","eyes","flower","giraffe","honey","idea","jump","knock knock","learn","mail time",
	"neptune","outside pool","power stance","quesadilla", "reptile", "turtle power", "until","visit friends",
	"wack"
]

var gibberish = [
	"wieonxvio", "ppwixlvj", "zienvlawl", "vbncn", "xmzlvxlwifnng", "wivh", "ciwls", "vdfipoushs", "awovn", "mbkf",
	"xdohgiugjd", "oewrvugh", "evun", "gbeno", "zawhiv", "qocklcid", "rivns", "nrgh", "oij owp", 
	"undgyt", "ohmlmk", "hofj ff", "nxot", "xyambu", "eibja", "goowlnvlz", "wppvjst", "lalsldlflglhl", 
	"cjeqlf", "yhnujm", "tixei", "appeppa", "fzw", "qpcol", "dlxn", 
	"yuwoeyy", "hslfjskk", "mnxbvb", "unlihj", "jkl jklj jkl", "fsfpi" 
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
	["papayas!", 2, "limes!", 2, "plums!", 2],
	["do you have pets?", 3],
	["yup", 4, "nah", 4, "lots of them!", 4],
	["what do you see?",  5],
	["wiggly creatures", 6, "pond with lily pads", 6, "my current score!", 6],
	["see anything else?", 7],
	["you", 8, "me", 8, "us",8],
	["can you help me?", 9],
	["yes", 10, "how?", 10, "no", 8],
	["my arm", 11],
	["way too swollen", 12, "circulation is cut off", 12, "infected wound", 12],
	["cut it off", 13],
	["knife", 18, "scissors", 18, "no", 14],
	["help me or i will die", 15],
	["help", 12, "refuse", 16, "leave", 24],
	["help me", 17],
	["help me", 14, "help me", 14, "help me", 14],
	["hard to cut through bone", 19],
	["break it", 20, "break it", 20, "break it", 20],
	["painful", 21],
	["i am sorry", 22, "be done soon", 22, "hang in there", 22],
	["cut the arm off", 23],
	["and cut it", 22, "then cut it more", 22, "until it is disconnected", 24],
]

func get_happy_prompt() -> String:
	var word_index = randi() % happy_words.size()
	var special_index = randi() % special_characters.size()
	
	var word = happy_words[word_index]
	var special_character = special_characters[special_index]
	
	return word + special_character

func get_salamander_prompt() -> String:
	return "salamander"

func get_gibberish_prompt() -> String:
	var word_index = randi() % gibberish.size()
	var special_index = randi() % special_characters.size()
	
	var word = gibberish[word_index]
	var special_character = special_characters[special_index]
	
	return word + special_character

#check if event_size > 1 to differentiate spawning the prompt or options
func get_event_size(event_number: int) -> int:
	return events[event_number].size()

func get_event_prompt(event_number: int, position: int) -> String:
	return events[event_number][position]

func get_next_event_number(event_number:int, position: int) -> int:
	return events[event_number][position+1]

