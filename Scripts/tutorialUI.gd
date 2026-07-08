extends CanvasLayer

export(float) var displayDuration = 4.0
export(float) var fadeDuration = 1.0
var timer = 0.0
var isShowing = false

func _ready():
	$Label.visible = false
	add_to_group("tutorial_ui")

func _process(delta):
	if not isShowing:
		return
	
	timer += delta
	
	if timer >= displayDuration + fadeDuration:
		$Label.visible = false
		isShowing = false
	elif timer >= displayDuration:
		var fadeProgress = (timer - displayDuration) / fadeDuration
		$Label.modulate.a = 1.0 - fadeProgress
	else:
		$Label.modulate.a = 1.0

func show_tip(text):
	$Label.text = text
	$Label.visible = true
	$Label.modulate.a = 1.0
	timer = 0.0
	isShowing = true
