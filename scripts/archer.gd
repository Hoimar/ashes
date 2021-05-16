extends Node2D

const ARROW = preload("res://scenes/arrow_controller.tscn")

onready var stage: Node2D = get_tree().get_nodes_in_group("stage")[0]


func _on_Stage_mouse_clicked(mouse_position):
	var arrow: Arrow = ARROW.instance()
	arrow.position = position
	arrow.target = mouse_position
	stage.add_child(arrow)
