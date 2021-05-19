extends Node2D

const ARROW = preload("res://scenes/arrow_controller.tscn")
const SHOOTING_DELAY = 0.5

enum STATE {
	IDLE,
	SHOOTING
}

var state = STATE.IDLE

onready var stage: Node = get_tree().get_nodes_in_group("stage")[0]
onready var anim_sprite := $AnimatedSprite
onready var arrow_offset := $ArrowOffset


func _on_Stage_mouse_clicked(mouse_position):
	if state == STATE.SHOOTING:
		return
	else:
		state = STATE.SHOOTING
		anim_sprite.play("shoot")
	yield(get_tree().create_timer(SHOOTING_DELAY), "timeout")
	var arrow: Arrow = ARROW.instance()
	arrow.global_position = arrow_offset.global_position
	arrow.target = mouse_position
	stage.add_child(arrow)


func _on_AnimatedSprite_animation_finished():
	if anim_sprite.animation == "shoot":
		state = STATE.IDLE
		anim_sprite.play("idle")
