class_name Enemy
extends Node2D

const SCORE_BONUS := 3.0
const SPEED := 15.0
const KNOCKBACK_DISTANCE := 50.0
const KNOCKBACK_DURATION := 1.5
const HEALTH_START := 3

enum STATE {
	CHASING,
	KNOCKBACK,
	DYING
}

var state := 0
var health := HEALTH_START
var facing_direction := -1
var damage := 1
var velocity := Vector2.ZERO
onready var knockback_tween := $KnockbackTween
onready var animation_player := $AnimationPlayer
onready var hero: Node2D = get_tree().get_nodes_in_group("hero")[0]
onready var stage: Node2D = get_tree().get_nodes_in_group("stage")[0]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == STATE.CHASING:
		var direction = (hero.global_position - global_position).normalized()
		position += direction * SPEED * delta


func take_hit(var amount := 1):
	health -= amount
	animation_player.play("hurt")
	if health <= 0:
		stage.increase_score(SCORE_BONUS)
		state = STATE.DYING
		queue_free()


func knockback(var source: Vector2):
	state = STATE.KNOCKBACK
	var vector = (source - global_position).normalized() * KNOCKBACK_DISTANCE
	knockback_tween.interpolate_property(self, "position", position, \
			position + vector, KNOCKBACK_DURATION,
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
	knockback_tween.start()


func _on_Hitbox_area_entered(var area: Area2D):
	if state == STATE.CHASING and area.get_parent() == hero:
		knockback(hero.global_position)


func _on_KnockbackTween_tween_completed(_object, _key):
	state = STATE.CHASING
