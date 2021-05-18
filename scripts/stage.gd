extends Node2D

const HERO_WALK_DURATION := 60.0
enum STATE {
	RUNNING,
	WON,
	LEVEL_COMPLETE
	LOST,
}

signal mouse_clicked(position)

var state := -1 setget set_state
var score := 0
onready var hero_path_follow := $Game/HeroPath/HeroPathFollow
onready var hero_path_tween := $HeroPathTween
onready var label_score := $UI/HBoxContainer/LabelScore
onready var label_health := $UI/HBoxContainer/LabelHealth
onready var levels := $Levels
onready var hero: Hero = get_tree().get_nodes_in_group("hero")[0]


# Called when the node enters the scene tree for the first time.
func _ready():
	hero.connect("hero_died", self, "set_state", [STATE.LOST])
	hero.connect("hero_hurt", self, "hero_health_changed")
	hero_health_changed(Hero.HEALTH_START)
	set_state(STATE.RUNNING)


func _input(event):
	if state == STATE.RUNNING \
		and (event is InputEventMouseMotion or event is InputEventMouseButton) \
		and Input.is_action_pressed("shoot"):
			pass


func _process(delta):
	if state == STATE.RUNNING and Input.is_action_pressed("shoot"):
		emit_signal("mouse_clicked", get_local_mouse_position())


func set_state(var new):
	if new == state:
		return
	match new:
		STATE.RUNNING:
			animate_hero_path()
		STATE.WON:
			print("You won the game!")
		STATE.LEVEL_COMPLETE:
			levels.level_num += 1
			print("Level complete!")
		STATE.LOST:
			print("You lost!")
			hero_path_tween.stop_all()
	state = new


func _on_HeroPathTween_tween_completed(_object, _key):
	set_state(STATE.LEVEL_COMPLETE)


func increase_score(var amount: int):
	score += amount
	label_score.text = "Score: %d" % score


func hero_health_changed(var new_health: int):
	label_health.set_text("Hero Health: %d/%d" \
			% [new_health, Hero.HEALTH_START])


func animate_hero_path():
	hero_path_tween.interpolate_property(hero_path_follow, "unit_offset", 0, 1, \
			HERO_WALK_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	hero_path_tween.start()
