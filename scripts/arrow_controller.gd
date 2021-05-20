class_name Arrow
extends Node2D

const TIME_DIST_FACTOR := 350.0   # flight path length / factor = duration in sec

var target: Vector2
onready var path := $Path2D
onready var path_follow := $Path2D/PathFollow2D
onready var tween := $Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	var target_pos := to_local(target)
	var length := target_pos.length()
	var turning_point := Vector2(target_pos.x / 2.0, \
			target_pos.y - length * 0.2)
	# Set correct curve positions.
	path.curve.set_point_position(1, turning_point)
	path.curve.set_point_position(2, target_pos)
	# Set correct control points.
	var control_point = Vector2(target_pos.x / 2.0, 0)
	path.curve.set_point_in(1, -control_point)
	path.curve.set_point_out(1, control_point)
	path.curve.set_point_out(0, Vector2(0, -length * 0.3))
	path.curve.set_point_in(2,  Vector2(0, 0))
	
	# Interpolate arrow flight.
	tween.interpolate_property(path_follow, "unit_offset", 0, 1.0, \
			length / TIME_DIST_FACTOR, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()


func _on_Tween_tween_completed(_object, _key):
	queue_free()
