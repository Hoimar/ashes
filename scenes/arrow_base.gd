extends Node2D

# Arrow has to face downwards to hit a target
const DOWNWARDS_DEGREE_MIN :=  90 + 10
const DOWNWARDS_DEGREE_MAX := 270 - 10

var damage := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_Hitbox_area_entered(area: Area2D):
	var deg := global_rotation_degrees
	#print(self, " entered ", area.get_parent(), " at ", deg)
	if      deg > DOWNWARDS_DEGREE_MIN \
		and deg < DOWNWARDS_DEGREE_MAX \
		and area.get_parent() is Enemy:
		var enemy = area.get_parent()
		enemy.take_hit(damage)
		queue_free()
