extends Sprite

export(String, MULTILINE) var tipText = "提示文字"

func _ready():
	$Area2D.connect("body_entered", self, "on_body_entered")
	$Area2D.connect("body_exited", self, "on_body_exited")

func on_body_entered(body):
	if body.is_in_group("player"):
		frame = 1
		get_tree().get_nodes_in_group("tutorial_ui")[0].show_tip(tipText)

func on_body_exited(body):
	if body.is_in_group("player"):
		frame = 0
		get_tree().get_nodes_in_group("tutorial_ui")[0].hide_tip()
