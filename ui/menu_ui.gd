extends CanvasLayer

@onready var gomc = $GOMC
@onready var score_label = $VBoxContainer/HB/ScoreLabel
@onready var difficulty_label = $VBoxContainer/HB/DifficultyLabel
@onready var life_point_label = $VBoxContainer/HB/LifePointLabel

@onready var tutorial_mc = $TutorialMC
@onready var final_score_label = $GOMC/VB/FinalScoreLabel
@onready var add_score_label = $VBoxContainer/HBoxContainer2/AddScoreLabel

@onready var names = $Names

@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer

@onready var pause_menu = $PauseMenu
var is_paused: bool = false

var score: int = 0
var difficulty: int = 0
var life_points: int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicController.play_salamander_theme()
	
	SignalManager.current_score.connect(get_current_score)
	SignalManager.current_difficulty.connect(get_current_difficulty)

func _unhandled_key_input(event):
	if event.is_action_pressed("start_button") and tutorial_mc.visible:
		animation_player.play("RESET")
		animation_player.play("Tutorial_to_Game")
		timer.start()
		start_game()
	if gomc.visible and event.is_action_pressed("start_button"):
		animation_player.play_backwards("Game_to_GameOver")
		timer.start()
		start_game()
	if !tutorial_mc.visible and !gomc.visible and event.is_action_pressed("start_button"):
		pause()

func pause() -> void:
		var current_value: bool = get_tree().paused
		is_paused = !is_paused
		
		if is_paused == true:
			pause_menu.visible = true
		else:
			pause_menu.visible = false
		get_tree().paused = !current_value

func start_game() -> void:
	score = 0
	difficulty = 0
	get_current_difficulty(0)
	get_current_score(0)
	set_life_points(3)
	SignalManager.start_game.emit()

func game_over() -> void:
	animation_player.play("Game_to_GameOver")
	gomc.show()
	names.show()
	add_score_label.text = ""
	if score > MusicController.get_high_score():
		final_score_label.text = "New High Score: " + str(score)
	else:
		final_score_label.text = "Score: " + str(score)

#need to get score and difficulty through signals
func get_current_score(current_score: int) -> void:
	score += current_score
	if score + current_score < 0:
		score = 0
		score_label.text = "Score: 0"
		return
	
	score_label.text = "Score: " + str(score)
	if current_score != 0:
		if current_score < 0:
			add_score_label.text = str(current_score)
		else:
			add_score_label.text = "+" +str(current_score)
		animation_player.play("add_score")

func get_current_difficulty(current_difficulty: int) -> void:
	difficulty = current_difficulty
	difficulty_label.text = "Difficulty: " + str(difficulty)

func set_life_points(current_life_points: int) -> void:
	life_points = current_life_points
	life_point_label.text = "Life Points: " + str(life_points)


func _on_timer_timeout():
	start_game()
	animation_player.play("RESET")
	if tutorial_mc.visible:
		tutorial_mc.hide()
	
	if gomc.visible:
		gomc.hide()
		names.hide()
		final_score_label.text = "Score: 0"
