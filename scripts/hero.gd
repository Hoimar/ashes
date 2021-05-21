class_name Hero
extends Node2D

const HEALTH_START := 5

enum STATE {
	WALKING,
	HURT,
	DYING,
}

signal hero_died
signal hero_hurt(health)

var state: int = STATE.WALKING
var health := HEALTH_START
onready var animation_player = $AnimationPlayer
onready var animated_sprite = $AnimatedSprite
onready var direction_finder = $DirectionFinder


func _process(var delta: float):
	if direction_finder.get_direction() == DirectionFinder.RIGHT:
		scale.x = -1
	else:
		scale.x = 1


func take_hit(var damage: int = 1):
	health -= damage
	animation_player.play("take_damage")
	if health <= 0:
		state = STATE.DYING
		emit_signal("hero_died")
		emit_signal("hero_hurt", health)
	else:
		state = STATE.HURT
		emit_signal("hero_hurt", health)


func _on_Hitbox_area_entered(var area: Area2D):
	if state == STATE.WALKING and area.get_parent() is Enemy:
		var enemy: Enemy = area.get_parent()
		take_hit(enemy.damage)


func _on_AnimationPlayer_animation_finished(var anim_name: String):
	if state == STATE.HURT and anim_name == "take_damage":
		state = STATE.WALKING
