class_name EnemySpawner
extends Node2D

const DISTANCE_TO_HERO := 75.0


var spawn_area: RectangleShape2D
var right_edge: float
onready var hero: Node2D = get_tree().get_nodes_in_group("hero")[0]


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is CollisionShape2D:
			spawn_area = child.shape
			right_edge = spawn_area.extents.x


func spawn(var scene: PackedScene):
	var valid_pos := false
	var side: int
	var pos: Vector2
	while !valid_pos:
		side = randi() % 2
		pos = Vector2(
				-right_edge if side == 0 else right_edge,
				randf() * spawn_area.extents.y * 2 - spawn_area.extents.y)
		if to_global(pos).distance_to(hero.global_position) > DISTANCE_TO_HERO:
			valid_pos = true
	var enemy: Enemy = scene.instance()
	enemy.position = pos
	enemy.facing_direction = side
	add_child(enemy)
	var enemy_width := enemy.get_hitbox().x
	enemy.position.x += -enemy_width if side == 0 else enemy_width
