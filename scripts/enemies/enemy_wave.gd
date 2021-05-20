class_name EnemyWave
extends Node2D

export var amount: int = 1
export var scene: PackedScene
export(float, 0.1, 600) var duration: float = 10
export(float, 0.1, 600) var cooldown: float = 10
onready var spawn_timer := $SpawnTimer
onready var cooldown_timer := $CooldownTimer
onready var target_node: EnemySpawner = get_tree().get_nodes_in_group("enemy_spawner")[0]
var num_spawned: int


# Called when the node enters the scene tree for the first time.
func _ready():
	var spawn_delay = duration / amount
	spawn_timer.wait_time = spawn_delay
	cooldown_timer.wait_time = cooldown
	spawn_timer.start()


func _on_SpawnTimer_timeout():
	target_node.spawn(scene)
	num_spawned += 1
	if num_spawned == amount:
		spawn_timer.stop()
		cooldown_timer.start()


func _on_CooldownTimer_timeout():
	num_spawned = 0
	spawn_timer.start()
