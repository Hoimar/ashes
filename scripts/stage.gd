extends Node2D

const HERO_WALK_DURATION := 60.0

enum STATE {
	RUNNING,
	WON,
	LOST,
}

signal mouse_clicked(position)

var state := -1 setget set_state
var score := 0
onready var hero_path_follow := $Game/HeroPath/HeroPathFollow
onready var hero_path_tween := $HeroPathTween
onready var score_label := $UI/HBoxContainer/LabelScore
onready var hero: Hero = get_tree().get_nodes_in_group("hero")[0]


# Called when the node enters the scene tree for the first time.
func _ready():
	hero.connect("hero_died", self, "set_state", [STATE.LOST])
	set_state(STATE.RUNNING)


func _input(event):
	if state == STATE.RUNNING and event is InputEventMouseButton and event.pressed:
		emit_signal("mouse_clicked", event.position)


func set_state(var new):
	if new == state:
		return
	match new:
		STATE.RUNNING:
			animate_hero_path()
		STATE.WON:
			print("You won!")
		STATE.LOST:
			print("You lost!")
			hero_path_tween.stop_all()
	state = new


func _on_HeroPathTween_tween_completed(object, key):
	set_state(STATE.WON)


func increase_score(var amount: int):
	score += amount
	score_label.text = "Score: %d" % score


func animate_hero_path():
	hero_path_tween.interpolate_property(hero_path_follow, "unit_offset", 0, 1, \
			HERO_WALK_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	hero_path_tween.start()
