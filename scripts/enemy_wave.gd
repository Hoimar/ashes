class_name EnemyWave
extends Node2D

signal wave_finished(wave)

export(float, 0.1, 600) var duration: float = 10
export(float, 0.1, 600) var cooldown: float = 10
onready var wave_timer := $WaveTimer
onready var cooldown_timer := $CooldownTimer
var num_spawned: int


# Called when the node enters the scene tree for the first time.
func _ready():
	wave_timer.wait_time = duration
	cooldown_timer.wait_time = cooldown


func _on_WaveTimer_timeout():
	print("Cooling down wave ", self)
	cooldown_timer.start()


func start():
	print("Starting wave ", self)
	for child in get_children():
		if child is EnemyGroup:
			child.start()
	wave_timer.start()


func _on_CooldownTimer_timeout():
	print("Finished wave ", self)
	emit_signal("wave_finished", self)
	queue_free()
