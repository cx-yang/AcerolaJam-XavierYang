extends CanvasLayer

@onready var gomc = $GOMC
@onready var score_label = $VBoxContainer/HB/ScoreLabel
@onready var difficultty_label = $VBoxContainer/HB/DifficulttyLabel

var score: int = 0
var difficulty: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	start_game()
	
	SignalManager.current_score.connect(get_current_score)
	SignalManager.current_difficulty.connect(get_current_difficulty)

func _on_restart_button_pressed():
	start_game()

func start_game() -> void:
	gomc.hide()
	score = 0
	difficulty = 0
	SignalManager.start_game.emit()

func game_over() -> void:
	gomc.show()
	

#need to get score and difficulty through signals
func get_current_score(current_score: int) -> void:
	score += current_score
	score_label.text = "Score: " + str(score)

func get_current_difficulty(current_difficulty: int) -> void:
	difficulty = current_difficulty
	difficultty_label.text = "Difficulty Level: " + str(difficulty)