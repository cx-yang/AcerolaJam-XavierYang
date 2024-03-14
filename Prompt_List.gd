extends Node

var happy_words = [
	"achievement","bubbles","comical","definite","empowered","favorite","gnarly","hospitable",
	"ideal","joysome","key","luminous","majestic","neighborly","organize","phenomenal",
	"quirk","recess","tubular","urbane","vivacious","wizard","xenodochial","yay","zealous",
	"add up","brown dog","cow tools","doing","funny","good job","hat","instant","jump","kitty","love","music","nice crock","ocelot",
	"party","quiz","red","tuba","umbrella","victory","wumbo","year","zoo","above you","birthday","cotton",
	"drink water","eyes","flower","giraffe","honey","pizza","jump","knock knock","learn","mail time",
	"neptune","outside pool","power","quesadilla", "fire lizard", "until", "visit friends",
	"wack", "joke", "fairy organization", "midnight pasta","concrete", "present", "sandwiches","allow",
	"mild","waterfall","new","yearn","joke","truth","key blade","waltz","rocket","catchphrase","passion","veil","mustard","picture","pocket",
	"hey","rhythm","cultivate","count","user","drive","polite","inn","blink","wish","try mimicry","ocean","ooze","vanilla","pride eternity",
	"future","breakfest","whoops","menagery","unlimted coupons","bedtime is fake","spare","big cheese","giant rat","with gratitude",
	"anthm","treehouse","milkshake","echo","fluff","gravity","good news","baby steps","inhale exhale","be safe",
	"for real","have fun","oh snap","think twice","matter","you first","yee haw","bug",
	"roll","honest","direct","foster","chart","revamp","flicker","upgrade","pitch","discover","jewel","knit","view","queue","code",
	"blue","daughter","lay","widen","multiply","tiger","replace","progress","marsh","mountain","island","bone","jelly","zenith","error","lamb","wind",
	"heroic","leader","protect","chrono","mill","first","pancake","penne","tycoon","hook","guard","magnetic","bald","light","honor","fella","madam",
	"inhibition","piano","density","how cute","special beam","rice shower","energy","voice","prompt","theater","toast","unfamiliar","choice","disk","explain",
	"palace","therapist","bargain","oak","feel","chef","mirror","sock","woosh"
]

var gibberish = [
	"dolor", "amet", "consectetur", "adipiscing", "elit", "zed", "do", "eiusmod", "tempor", "incididunt", "ut", "agna", "aliqua",
	 "lem", "nulla", "pharetra", "diam", "tristique", "purus", "gravida", "blandit", "turpis", "cursus",
	 "volutpat", "velit", "egestas", "dui", "ornare", "mi", "in", "ultrices", "maecenas", "enim", "neque",
	 "risus", "laoreet", "interdum", "feugiat", "fusce", "elementum", "gravida", "ornare", "platea", "nibh", "quisque", "venenatis",
	 "uet", "rhoncus", "porttitor", "habitant", "bibendum", "del"
]

#String is the prompt. Number after is the array position to make the event handler go to
var events = [
	["do you like fruit", 1],
	["papayas", 2, "limes", 2, "watermelon", 2],
	["do you have pets", 3],
	["yup", 4, "nah", 4, "lots of them", 4],
	["what do you see", 5],
	["wiggly creatures", 6, "pond with lily pads", 6, "my current score", 6],
	["see anything else", 7],
	["you", 8, "me", 8, "us",8],
	["can you help me", 9],
	["yes", 10, "how", 10, "no", 8],
	["look at my arm", 11],
	["way too swollen", 12, "circulation is cut off", 12, "infected wound", 12],
	["prepare to cut the arm", 13],
	["knife", 18, "scissors", 18, "no", 14],
	["help me or i will die", 15],
	["help", 12, "refuse", 16, "leave", 24],
	["help me", 17],
	["help me", 14, "help me", 14, "help me", 14],
	["hard to cut through bone", 19],
	["break it", 20, "break it", 20, "break it", 20],
	["painful", 21],
	["i am sorry", 22, "be done soon", 22, "hang in there", 22],
	["cut into the arm", 23],
	["and cut it", 22, "then cut it more", 22, "until it is disconnected", 24],
]

func get_happy_prompt() -> String:
	return get_prompt(happy_words)

func get_gibberish_prompt() -> String:
	return get_prompt(gibberish)

func get_prompt(array_type: Array) -> String:
	var word_index = randi() % array_type.size()
	var word = array_type[word_index]
	return word

func get_salamander_prompt() -> String:
	return "salamander"

#check if event_size > 1 to differentiate spawning the prompt or options
func get_event_size(event_number: int) -> int:
	return events[event_number].size()

func get_event_prompt(event_number: int, position: int) -> String:
	return events[event_number][position]

func get_next_event_number(event_number:int, position: int) -> int:
	return events[event_number][position+1]

