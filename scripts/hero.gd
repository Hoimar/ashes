class_name Hero
extends Node2D

const HEALTH_START := 5

enum STATE {
	WALKING,
	HURT,
	DYING,
}

signal hero_died

var state: int = STATE.WALKING
var health := HEALTH_START
onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func take_hit(var damage: int = 1):
	health -= damage
	animation_player.play("take_damage")
	if health <= 0:
		state = STATE.DYING
		emit_signal("hero_died")
	else:
		state = STATE.HURT


func _on_Hitbox_area_entered(var area: Area2D):
	if state == STATE.WALKING and area.get_parent() is Enemy:
		var enemy: Enemy = area.get_parent()
		take_hit(enemy.damage)


func _on_AnimationPlayer_animation_finished(var anim_name: String):
	if state == STATE.HURT and anim_name == "take_damage":
		state = STATE.WALKING
