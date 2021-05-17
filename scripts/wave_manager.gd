extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_children():
		if node is EnemyWave:
			node.connect("wave_finished", self, "wave_finished")
	start_top_wave()


func wave_finished(var wave: EnemyWave):
	remove_child(wave)
	start_top_wave()


func start_top_wave():
	if get_child_count() == 0:
		return
	var wave: EnemyWave = get_children().front()
	wave.start()
