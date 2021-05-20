extends Node

const STAGE := preload("res://scenes/gamestates/stage.tscn")
const POPUP := preload("res://scenes/gamestates/game_popup.tscn")
const ENDING := preload("res://scenes/gamestates/ending.tscn")

const MAX_LEVELS := 4
enum STATE {
	RUNNING,
	GAME_WON,
	LEVEL_COMPLETE
	LOST,
}

var level: int = 0
var state: int
var score: int


func start_level(var next: bool = false):
	if next:
		level += 1
	if level == MAX_LEVELS:
		# TODO: Show ending.
		get_tree().change_scene_to(ENDING)
	else:
		set_state(STATE.RUNNING)
		get_tree().change_scene_to(STAGE)


func set_state(var new):
	if new == state:
		return
	state = new
	if state == STATE.RUNNING:
		get_tree().paused = false
	else:
		get_tree().paused = true
		get_tree().get_root().add_child(POPUP.instance())
