extends Node2D

const ARROW = preload("res://scenes/arrow_controller.tscn")
const SHOOTING_DELAY = 0.5
const COOLDOWN_FRAME := 5

enum STATE {
	IDLE,
	SHOOTING
}

var state = STATE.IDLE

onready var stage: Node = get_tree().get_nodes_in_group("stage")[0]
onready var anim_sprite := $AnimatedSprite
onready var arrow_offset := $ArrowOffset
onready var shooting_delay_timer := $ShootingDelayTimer


func _on_Stage_mouse_clicked():
	if state == STATE.SHOOTING:
		if anim_sprite.frame > COOLDOWN_FRAME:
			return
			# TODO
			_on_AnimatedSprite_animation_finished()
		else:
			return
	state = STATE.SHOOTING
	anim_sprite.play("shoot")
	shooting_delay_timer.start()


func _on_AnimatedSprite_animation_finished():
	if anim_sprite.animation == "shoot":
		state = STATE.IDLE
		anim_sprite.play("idle")



func _on_ShootingDelayTimer_timeout():
	var arrow: Arrow = ARROW.instance()
	arrow.global_position = arrow_offset.global_position
	arrow.target = get_global_mouse_position()
	stage.add_child(arrow)
