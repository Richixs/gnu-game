extends CanvasLayer

@onready var hud = $HUD
@onready var score_label = $HUD/ScoreLabel
@onready var main_menu = $MainMenu
@onready var game_over_menu = $GameOverMenu
@onready var register_menu = $RegisterMenu
@onready var scoreboard_menu = $ScoreboardMenu
@onready var controls_menu = $ControlsMenu
@onready var initials_input = $RegisterMenu/InitialsInput
@onready var score_list = $ScoreboardMenu/ScrollContainer/ScoreList

var mock_db = [
	{"name": "RIC", "score": 1500, "date": "24"},
	{"name": "GNU", "score": 3200, "date": "24"},
	{"name": "DEV", "score": 4100, "date": "25"}
]

func _ready():
	if Global.score_updated.is_connected(_on_score_updated):
		Global.score_updated.disconnect(_on_score_updated)
	Global.score_updated.connect(_on_score_updated)
	if Global.game_over_triggered.is_connected(show_game_over):
		Global.game_over_triggered.disconnect(show_game_over)
	Global.game_over_triggered.connect(show_game_over)
	
	if Global.is_restarting:
		Global.is_restarting = false
		show_screen(null)
		Global.reset_game() 
	else:
		get_tree().paused = true
		show_screen(main_menu)

func _on_score_updated(new_score: int):
	score_label.text = "SCORE: %05d" % new_score

func show_screen(screen_to_show: Control):
	main_menu.hide()
	game_over_menu.hide()
	register_menu.hide()
	scoreboard_menu.hide()
	controls_menu.hide()
	
	if screen_to_show != null:
		screen_to_show.show()
		
	hud.visible = (screen_to_show == null)

func _on_btn_play_pressed():
	show_screen(null)
	Global.reset_game()
	get_tree().reload_current_scene()

func _on_btn_controls_pressed():
	show_screen(controls_menu)

func _on_btn_scoreboard_pressed():
	load_scoreboard("All")
	show_screen(scoreboard_menu)

func show_game_over():
	show_screen(game_over_menu)

func _on_btn_play_again_pressed():
	_on_btn_play_pressed()

func _on_btn_register_pressed():
	show_screen(register_menu)
	initials_input.clear()
	initials_input.grab_focus()

func _on_btn_save_pressed():
	var initials = initials_input.text.to_upper()
	if initials.length() == 3:
		mock_db.append({"name": initials, "score": int(Global.actual_score), "date": "24"})
		load_scoreboard("All")
		show_screen(scoreboard_menu)
	else:
		print("Deben ser exactamente 3 letras")

func load_scoreboard(filter_date: String):
	for child in score_list.get_children():
		child.queue_free()
		
	var filtered_scores = []
	for entry in mock_db:
		if filter_date == "All" or entry["date"] == filter_date:
			filtered_scores.append(entry)
			
	filtered_scores.sort_custom(func(a, b): return a["score"] > b["score"])
	
	for i in range(filtered_scores.size()):
		var entry = filtered_scores[i]
		var label = Label.new()
		label.text = str(i+1) + ". " + entry["name"] + " - " + str(entry["score"])
		score_list.add_child(label)

func _on_btn_day_24_pressed():
	load_scoreboard("24")

func _on_btn_day_25_pressed():
	load_scoreboard("25")

func _on_btn_all_pressed():
	load_scoreboard("All")

func _on_btn_close_pressed():
	show_screen(main_menu)

func _on_btn_close_controls_pressed() -> void:
	show_screen(main_menu)
