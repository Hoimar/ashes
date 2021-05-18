extends Node

var level_num = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_child_count() == 0:
		return
	var wave: EnemyWave = get_children()[level_num]
	wave.start()
