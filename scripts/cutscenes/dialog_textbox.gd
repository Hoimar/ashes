extends Control

const CHARACTER_DELAY := 0.04

enum STATE {
	RUNNING_TEXT,
	WAITING,
}

var dialog := [
	DialogPart.new(
		"", Color.blueviolet,
		"Would they remember me if I had died in their place? I only had their ashes left and even that was taken from me. Dad, Mom, Brother. I'll get you back. Even though I'm not strong enough. I hired the best hero in the region. He will be able to stand up to the Kodamas."
	),
	DialogPart.new(
		"HERO", Color.darkblue,
		"Hurry up, girl. Is that your house? It looks pretty bad. Anyway. I'll be back."
	),
	DialogPart.new(
		"ARKI", Color.greenyellow,
		"Wait, won't you wait until the night? The Kodamas are awake now."
	),
	DialogPart.new(
		"HERO", Color.darkblue,
		"Wait until the night? You just wait for me here and get the bag of coins ready."
	),
	DialogPart.new(
		"", Color.blueviolet,
		"..."
	),
	DialogPart.new(
		"ARKI", Color.greenyellow,
		"Maybe the hero needs a little help..."
	),
]


var state: int
var current_part: int
onready var label := $DialogTextbox/RichTextLabel
onready var tween_text := $TweenText


# Called when the node enters the scene tree for the first time.
func _ready():
	show_next_part()


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if state == STATE.RUNNING_TEXT:
			tween_text.stop_all()
			label.percent_visible = 1.0
			state = STATE.WAITING
		elif state == STATE.WAITING:
			show_next_part()


func show_next_part():
	if current_part == dialog.size():
		Global.start_sequence(true)
		return
	state = STATE.RUNNING_TEXT
	var part: DialogPart = dialog[current_part]
	var text := ""
	if not part.name.empty():
		text = "[color=#%s]%s[/color]\n" \
				% [part.name_color.to_html(false), part.name]
	text += part.text
	label.percent_visible = 0.0
	label.bbcode_text = text
	tween_text.interpolate_property(label, "percent_visible", 0, 1, \
			text.length() * CHARACTER_DELAY)
	tween_text.start()
	current_part += 1


class DialogPart:
	var name: String
	var name_color: Color
	var text: String
	
	func _init(_name: String, _name_color: Color, _text: String):
		name = _name
		name_color = _name_color
		text = _text
