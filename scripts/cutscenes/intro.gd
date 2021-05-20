extends Control

onready var animation_player := $AnimationPlayer

func _ready():
	animation_player.play("text_scroll")


func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		Global.start_level(true)


func _on_AnimationPlayer_animation_finished(anim_name):
	Global.start_level(true)
