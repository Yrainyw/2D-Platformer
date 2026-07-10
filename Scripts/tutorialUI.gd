extends CanvasLayer

export(float) var fadeDuration = 2

var isFading = false
var fadeTimer = 0.0

func _ready():
	$Label.visible = false
	add_to_group("tutorial_ui")

func _process(delta):
	if not isFading:
		return

	fadeTimer += delta
	var fadeProgress = fadeTimer / fadeDuration

	if fadeProgress >= 1.0:
		$Label.visible = false
		isFading = false
	else:
		$Label.modulate.a = 1.0 - fadeProgress

func show_tip(text):
	isFading = false
	$Label.text = text
	$Label.visible = true
	$Label.modulate.a = 1.0

func hide_tip():
	isFading = true
	fadeTimer = 0.0
