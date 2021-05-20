class_name Stage
extends CanvasItem

const HERO_WALK_DURATION := 60.0

signal mouse_clicked(position)

onready var hero_path_follow := $Game/HeroPath/HeroPathFollow
onready var hero_path_tween := $HeroPathTween
onready var label_score := $UI/HBoxContainer/LabelScore
onready var label_health := $UI/HBoxContainer/LabelHealth
onready var hero: Hero = get_tree().get_nodes_in_group("hero")[0]


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	hero.connect("hero_died", self, "lose")
	hero.connect("hero_hurt", self, "hero_health_changed")
	hero_health_changed(Hero.HEALTH_START)
	animate_hero_path()


func _process(delta):
	if Global.state == Global.STATE.RUNNING and Input.is_action_pressed("shoot"):
		emit_signal("mouse_clicked", get_local_mouse_position())


func lose():
	hero_path_tween.stop_all()
	Global.set_state(Global.STATE.LOST)


func _on_HeroPathTween_tween_completed(_object, _key):
	Global.set_state(Global.STATE.LEVEL_COMPLETE)


func increase_score(var amount: int):
	Global.score += amount
	label_score.text = "Score: %d" % Global.score


func hero_health_changed(var new_health: int):
	label_health.set_text("Hero Health: %d/%d" \
			% [new_health, Hero.HEALTH_START])


func animate_hero_path():
	hero_path_tween.interpolate_property(hero_path_follow, "unit_offset", 0, 1, \
			HERO_WALK_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	hero_path_tween.start()
