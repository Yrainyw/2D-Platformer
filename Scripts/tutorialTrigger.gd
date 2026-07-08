extends Area2D

export(String, MULTILINE) var tipText = "提示文字"

func _ready():
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if body.is_in_group("player"):
		get_tree().get_nodes_in_group("tutorial_ui")[0].show_tip(tipText)
		call_deferred("disable_shape")

func disable_shape():
	$CollisionShape2D.disabled = true
