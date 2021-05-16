extends Node2D

const ENEMY := preload("res://scenes/enemy.tscn")

var spawn_area: RectangleShape2D
onready var right_edge := get_viewport_rect().size.x


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is CollisionShape2D:
			spawn_area = child.shape


func _on_Timer_timeout():
	var enemy: Node2D = ENEMY.instance()
	var side: int = randi() % 2
	var x: float = 0 if side == 0 else right_edge
	var y: float = randf() * spawn_area.extents.y
	var pos := Vector2(x, y)
	enemy.position = pos
	enemy.direction = side
	add_child(enemy)
