class_name EnemySpawner
extends Node2D


var spawn_area: RectangleShape2D
onready var right_edge := get_viewport_rect().size.x


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is CollisionShape2D:
			spawn_area = child.shape


func spawn(var scene: PackedScene):
	var side: int = randi() % 2
	var x: float = 0.0 if side == 0 else right_edge
	var y: float = randf() * spawn_area.extents.y * 2
	var enemy: Enemy = scene.instance()
	enemy.position = Vector2(x, y)
	enemy.facing_direction = side
	add_child(enemy)
	var enemy_width := enemy.get_hitbox().x * 2
	enemy.position.x += enemy_width if side == 1 else -enemy_width

