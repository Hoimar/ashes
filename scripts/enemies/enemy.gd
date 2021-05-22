class_name Enemy
extends Node2D

const SPEED := 15.0
const KNOCKBACK_DISTANCE := 35.0
const KNOCKBACK_DURATION := 1.0
const HEALTH_BASIC := 2

enum STATE {
	CHASING,
	KNOCKBACK,
	DYING
}

export var health := HEALTH_BASIC
var state := 0
var facing_direction := -1
var damage := 1
onready var knockback_tween := $KnockbackTween
onready var animation_player := $AnimationPlayer
onready var animated_sprite := $AnimatedSprite
onready var hitbox_shape := $Hitbox/CollisionShape2D
onready var direction_finder := $DirectionFinder
onready var sfx_player := $AudioStreamPlayer2D
onready var hero: Node2D = get_tree().get_nodes_in_group("hero")[0]
onready var stage: Node = get_tree().get_nodes_in_group("stage")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == STATE.CHASING:
		var direction = (hero.global_position - global_position).normalized()
		position += direction * SPEED * delta
		# Set sprite direction.
		if direction_finder.get_direction() == DirectionFinder.RIGHT:
			scale.x = -1
		else: 
			scale.x = 1


func take_hit(var amount := 1):
	health -= amount
	animation_player.play("hurt")
	Global.play_sound(sfx_player.stream, global_position)
	if health <= 0:
		state = STATE.DYING
		queue_free()


func knockback(var source: Vector2):
	state = STATE.KNOCKBACK
	var vector = (global_position - source).normalized() * KNOCKBACK_DISTANCE
	knockback_tween.interpolate_property(self, "position", position, \
			position + vector, KNOCKBACK_DURATION,
			Tween.TRANS_QUAD, Tween.EASE_OUT)
	knockback_tween.start()


func _on_Hitbox_area_entered(var area: Area2D):
	if state == STATE.CHASING and area.get_parent() == hero:
		knockback(hero.global_position)


func _on_KnockbackTween_tween_completed(_object, _key):
	state = STATE.CHASING
	direction_finder.last_position = position


func get_hitbox() -> Vector2:
	return hitbox_shape.shape.extents
