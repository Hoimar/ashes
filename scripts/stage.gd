extends Node2D

signal mouse_clicked(position)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
   # Mouse in viewport coordinates.
   if event is InputEventMouseButton and event.pressed:
	   emit_signal("mouse_clicked", event.position)
