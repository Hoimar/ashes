extends Node

signal finished

var target_scene
var audio_bus_music: int = AudioServer.get_bus_index("Music")
var volume_start := AudioServer.get_bus_volume_db(audio_bus_music)
onready var animation_player := $AnimationPlayer
onready var tween_fade_out_music := $TweenFadeOutMusic


func _ready():
	var fade_length: float = \
			animation_player.get_animation("transition").length / 2
	tween_fade_out_music.interpolate_method(self, "set_music_volume",
			volume_start, -80.0, fade_length, \
			Tween.TRANS_QUAD, Tween.EASE_IN)
	animation_player.play("transition")
	tween_fade_out_music.start()


func change_to_target_scene():
	if target_scene is PackedScene:
		get_tree().change_scene_to(target_scene)
	elif target_scene is String:
		get_tree().change_scene(target_scene)
	yield(get_tree(), "idle_frame")   # Await scene change.
	get_viewport().move_child(self, self.get_position_in_parent()+1)
	AudioServer.set_bus_volume_db(audio_bus_music, volume_start)


func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal("finished")
	queue_free()


func set_music_volume(var new: float):
	AudioServer.set_bus_volume_db(audio_bus_music, new)
