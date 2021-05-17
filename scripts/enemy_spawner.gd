class_name EnemySpawner
extends Node2D

const SPAWN_OFFSET := 16.0

var spawn_area: RectangleShape2D
onready var right_edge := get_viewport_rect().size.x


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is CollisionShape2D:
			spawn_area = child.shape


func spawn(var scene: PackedScene):
	var side: int = randi() % 2
	var offset = SPAWN_OFFSET if side == 1 else -SPAWN_OFFSET
	var x: float = 0.0 if side == 0 else right_edge
	var y: float = randf() * spawn_area.extents.y * 2
	var pos := Vector2(x + offset, y)
	var enemy: Enemy = scene.instance()
	enemy.position = pos
	enemy.facing_direction = side
	add_child(enemy)
