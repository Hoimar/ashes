extends Control


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		Global.level = 0
		Global.set_state(Global.STATE.GAME_WON)
