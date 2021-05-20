extends Control

onready var button_exit := $CenterContainer/VBoxContainer/VBoxButtons/ButtonExit

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_name() == "HTML5":
		button_exit.disabled = true


func _on_ButtonPlay_pressed():
	get_tree().change_scene_to(Global.STAGE)


func _on_ButtonExit_pressed():
	get_tree().quit()
