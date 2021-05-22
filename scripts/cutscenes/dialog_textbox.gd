extends Control

const CHARACTER_DELAY := 0.04


enum STATE {
	RUNNING_TEXT,
	WAITING,
}

var char_narrator = DialogCharacter.new("", Color.black, null)
var char_hero     = DialogCharacter.new("HERO", Color.darkblue,
		preload("res://assets/sprites/hero portrait.png"))
var char_arki     = DialogCharacter.new("ARKI", Color.greenyellow,
		preload("res://assets/sprites/portrait arki.png"))

var dialog := [
	DialogPart.new(
		char_narrator,
		"Would they remember me if I had died in their place? I only had their ashes left and even that was taken from me. Dad, Mom, Brother. I'll get you back. Even though I'm not strong enough. I hired the best hero in the region. He will be able to stand up to the Kodamas."
	),
	DialogPart.new(
		char_hero,
		"Hurry up, girl. Is that your house? It looks pretty bad. Anyway. I'll be back."
	),
	DialogPart.new(
		char_arki,
		"Wait, won't you wait until the night? The Kodamas are awake now."
	),
	DialogPart.new(
		char_hero,
		"Wait until the night? You just wait for me here and get the bag of coins ready."
	),
	DialogPart.new(
		char_narrator,
		"..."
	),
	DialogPart.new(
		char_arki,
		"Maybe the hero needs a little help..."
	),
]


var state: int = STATE.RUNNING_TEXT
var current_part: int
onready var label := $DialogTextbox/VBoxContainer/RichTextLabel
onready var portrait := $DialogTextbox/VBoxContainer/TextureRect
onready var tween_text := $TweenText
onready var sfx_voice_high := $AudioStreamPlayer2DHigh
onready var sfx_voice_low := $AudioStreamPlayer2DLow


# Called when the node enters the scene tree for the first time.
func _ready():
	show_next_part()


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if state == STATE.RUNNING_TEXT:
			tween_text.stop_all()
			label.percent_visible = 1.0
			_on_TweenText_tween_completed()
		elif state == STATE.WAITING:
			show_next_part()
	if state == STATE.RUNNING_TEXT and not current_part == dialog.size():
		if dialog[current_part].character == char_arki \
		   and not sfx_voice_high.is_playing():
			sfx_voice_high.play()
			print(STATE.keys()[state], " high")
		if dialog[current_part].character == char_hero \
		   and not sfx_voice_low.is_playing():
			sfx_voice_low.play()
			print(STATE.keys()[state], " low")


func show_next_part():
	if current_part == dialog.size():
		Global.start_sequence(true)
		return
	state = STATE.RUNNING_TEXT
	var part: DialogPart = dialog[current_part]
	var text := ""
	
	if part.character.portrait:
		portrait.texture = part.character.portrait
	else:
		portrait.texture = null
	
	if not part.character.name.empty():
		text = "[color=#%s]%s[/color]\n" \
				% [part.character.name_color.to_html(false), part.character.name]

	text += part.text
	label.percent_visible = 0.0
	label.bbcode_text = text
	tween_text.interpolate_property(label, "percent_visible", 0, 1, \
			text.length() * CHARACTER_DELAY)
	tween_text.start()


func _on_TweenText_tween_completed(_object = null, _key = null):
	state = STATE.WAITING
	current_part += 1


class DialogPart:
	var character: DialogCharacter
	var text: String
	
	func _init(_character: DialogCharacter, _text: String):
		character = _character
		text = _text


class DialogCharacter:
	var name: String
	var name_color: Color
	var portrait: Texture
	
	func _init(_name: String, _name_color: Color, _portrait: Texture):
		name = _name
		name_color = _name_color
		portrait = _portrait

