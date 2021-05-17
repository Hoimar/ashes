class_name EnemyGroup
extends Node2D

export var amount: int = 1
export var scene: PackedScene
export(float, 0.1, 600) var duration: float = 10
export(float, 0.0, 600) var delay: float = 0
onready var delay_timer := $DelayTimer
onready var spawn_timer := $SpawnTimer
var num_spawned: int
onready var target_node: EnemySpawner = get_tree().get_nodes_in_group("enemy_spawner")[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	if delay > 0:
		delay_timer.wait_time = delay
	var spawn_delay = duration / amount
	spawn_timer.wait_time = spawn_delay


func _on_SpawnTimer_timeout():
	target_node.spawn(scene)
	num_spawned += 1
	if num_spawned == amount:
		spawn_timer.stop()


func start():
	if delay > 0:
		delay_timer.start()
	else:
		_on_DelayTimer_timeout()


func _on_DelayTimer_timeout():
	spawn_timer.start()
