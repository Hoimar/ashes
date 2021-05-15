class_name Arrow
extends Node2D

const FLIGHT_DURATION := 1.0


var target: Vector2
onready var path := $Path2D
onready var path_follow := $Path2D/PathFollow2D
onready var tween := $Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	path.curve.set_point_position(1, to_local(target))
	tween.interpolate_property(path_follow, "unit_offset", 0, 1, \
			FLIGHT_DURATION, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()


func _on_Tween_tween_completed(object, key):
	queue_free()
