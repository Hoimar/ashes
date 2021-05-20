class_name DirectionFinder
extends Node2D
# Finds direction of parent node based on position delta.

# Easier than enum.
const UP = 0
const DOWN = 1
const LEFT = 2
const RIGHT = 3

export var only_x_axis: bool = false
var last_position: Vector2
var parent: Node2D
var direction: int setget , get_direction


# Called when the node enters the scene tree for the first time.
func _ready():
	if not get_parent() is Node2D:
		print("Error: Can't find direction on non Node2D parent: ", get_parent())
	parent = get_parent()
	last_position = parent.global_position


func _process(var delta: float):
	var current_position := parent.global_position
	var delta_p := last_position - current_position
	last_position = current_position
	
	if only_x_axis:
		direction = LEFT if delta_p.x < 0 else RIGHT
	else:
		var angle := delta_p.angle()
		if angle > -PI/4 and angle <= PI/4:
			direction = RIGHT
		elif angle > PI/4 and angle <= PI/2 + PI/4:
			direction = DOWN
		elif angle > PI/2 + PI/4 and angle <= PI + PI/4:
			direction = LEFT
		else:
			direction = UP


func get_direction() -> int:
	return direction
