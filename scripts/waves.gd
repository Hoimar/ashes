extends Node

onready var stage: Stage = get_tree().get_nodes_in_group("stage")[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_child_count() == 0 or get_children().size() <= Global.level:
		return
	var wave: EnemyWave = get_children()[Global.level]
	wave.start()
