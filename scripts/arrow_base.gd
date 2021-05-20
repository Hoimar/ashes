extends Node2D

# Arrow has to face downwards to hit a target
const DOWNWARDS_DEGREE_MIN :=  90 + 10
const DOWNWARDS_DEGREE_MAX := 270 - 10

var damage := 1
onready var hitbox := $Hitbox


func _process(var delta: float):
	var deg := global_rotation_degrees
	if      deg < DOWNWARDS_DEGREE_MIN \
		or deg > DOWNWARDS_DEGREE_MAX:
		return
	var areas: Array = hitbox.get_overlapping_areas()
	for area in areas:
		if area.get_parent() is Enemy:
			var enemy = area.get_parent()
			enemy.take_hit(damage)
			queue_free()
