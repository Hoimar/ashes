class_name EnemyGroup
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var spawn_delay = duration / amount
	spawn_timer.wait_time = spawn_delay


func _on_SpawnTimer_timeout():
	target_node.spawn(scene)
	num_spawned += 1
	if num_spawned == amount:
		spawn_timer.stop()


func start():
	
