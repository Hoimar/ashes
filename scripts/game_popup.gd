class_name GamePopup
extends CenterContainer


onready var label_message := $PanelContainer/VBoxContainer/LabelMessage
onready var button_retry := $PanelContainer/VBoxContainer/HBoxContainer/ButtonRetry
onready var button_continue := $PanelContainer/VBoxContainer/HBoxContainer/ButtonContinue


# Called when the node enters the scene tree for the first time.
func _ready():
	match Global.state:
		Global.STATE.LEVEL_COMPLETE:
			label_message.text = "Level complete!"
		Global.STATE.GAME_WON:
			label_message.text = "You completed the game, congrats!"
		Global.STATE.LOST:
			label_message.text = "The hero died."
			button_continue.disabled = true


func _on_ButtonRetry_pressed():
	Global.start_level()
	queue_free()


func _on_ButtonContinue_pressed():
	Global.start_level(true)
	queue_free()
