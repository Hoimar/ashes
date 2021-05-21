extends Node

const STAGE := preload("res://scenes/gamestates/stage.tscn")
const POPUP := preload("res://scenes/gamestates/game_popup.tscn")
const MAIN_MENU := preload("res://scenes/gamestates/main_menu.tscn")
const LEVELS := "res://scenes/levels/level%d.tscn"
const CUTSCENES := "res://scenes/cutscenes/%s.tscn"

const GAME_SEQUENCE = [
	CUTSCENES % "intro",
	LEVELS % 1,
	LEVELS % 2,
	LEVELS % 3,
	LEVELS % 4,
	CUTSCENES % "ending",
]

const MAX_LEVELS := 4
enum STATE {
	RUNNING,
	GAME_WON,
	LEVEL_COMPLETE
	LOST,
	PAUSED,
	BACK_TO_MENU,
}

var level: int = 0
var state: int


func start_level(var next: bool = false):
	if state == STATE.PAUSED:
		set_state(STATE.RUNNING)
	else:
		if next:
			level += 1
		get_tree().change_scene(GAME_SEQUENCE[level])
	set_state(STATE.RUNNING)


func set_state(var new):
	if new == state:
		return
	state = new
	if state == STATE.BACK_TO_MENU:
		get_tree().paused = false
		get_tree().change_scene_to(MAIN_MENU)
	elif state == STATE.RUNNING:
		get_tree().paused = false
	else:
		get_tree().paused = true
		get_tree().get_root().add_child(POPUP.instance())
