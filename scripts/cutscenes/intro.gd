extends Control

onready var animation_player := $AnimationPlayer

func _ready():
	animation_player.play("text_scroll")


func _process(_delta):
	if Input.is_action_pressed("ui_accept"):
		Global.start_sequence(true)


func _on_AnimationPlayer_animation_finished(_anim_name):
	Global.start_sequence(true)
