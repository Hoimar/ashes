extends Node

const STAGE := preload("res://scenes/stage.tscn")
const POPUP := preload("res://scenes/game_popup.tscn")

const MAX_LEVELS := 4
enum STATE {
	RUNNING,
	GAME_WON,
	LEVEL_COMPLETE
	LOST,
}

var level: int = 0
var state: int


func start_level(var next: bool = false):
	if next:
		level += 1
	if level == MAX_LEVELS:
		# TODO: Show ending.
		pass
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
		var popup = POPUP.instance()
		get_tree().get_root().add_child(popup)
