extends Node

const STAGE := preload("res://scenes/gamestates/stage.tscn")
const POPUP := preload("res://scenes/gamestates/game_popup.tscn")
const MAIN_MENU := preload("res://scenes/gamestates/main_menu.tscn")
const SCENE_TRANSITIONER := preload("res://scenes/gamestates/scene_transitioner.tscn")

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

enum STATE {
	RUNNING,
	GAME_WON,
	LEVEL_COMPLETE
	LOST,
	PAUSED,
	BACK_TO_MENU,
	MENU,
	TRANSITIONING,
}

var level: int = 0
var state: int = STATE.RUNNING


func _ready():
	set_pause_mode(Node.PAUSE_MODE_PROCESS)


func _process(_delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.set_window_fullscreen(!OS.is_window_fullscreen())


func start_sequence(var next: bool = false):
	if state == STATE.PAUSED:
		set_state(STATE.RUNNING)
	elif not state == STATE.TRANSITIONING:
		if next:
			level += 1
		transition_to(GAME_SEQUENCE[level])


func set_state(var new):
	if new == state:
		return
	state = new
	match state:
		STATE.BACK_TO_MENU, STATE.GAME_WON:
			transition_to(MAIN_MENU)
		STATE.RUNNING:
			get_tree().paused = false
		STATE.LOST, STATE.LEVEL_COMPLETE, STATE.PAUSED:
			get_tree().paused = true
			get_tree().get_root().add_child(POPUP.instance())


# Either PackedScene or path to scene.
func transition_to(var target_scene):
	if state == STATE.TRANSITIONING:
		return
	set_state(STATE.TRANSITIONING)
	var transitioner := SCENE_TRANSITIONER.instance()
	transitioner.target_scene = target_scene
	transitioner.connect("finished", self, "_on_transition_finished")
	get_tree().get_root().add_child(transitioner)


func _on_transition_finished():
	get_tree().paused = false
	set_state(STATE.RUNNING)


func play_sound(var stream: AudioStream, var pos: Vector2 = Vector2.ZERO):
	if pos != Vector2.ZERO:
		var asp2d = AudioStreamPlayer2D.new()
		asp2d.stream = stream
		asp2d.position = pos
		asp2d.connect("finished", asp2d, "queue_free")
		add_child(asp2d)
		asp2d.play()
	else:
		var asp = AudioStreamPlayer.new()
		asp.stream = stream
		asp.connect("finished", asp, "queue_free")
		add_child(asp)
		asp.play()
