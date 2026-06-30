extends Camera2D

export(Color, RGB) var backgroundColor
export(float, 0.0, 0.999) var smoothing = 0.0001 # 数值越小,跟随越紧;越接近1,跟随越松,拖尾感越强

var targetPosition := Vector2.ZERO

func _ready():
	VisualServer.set_default_clear_color(backgroundColor)

func _process(delta):
	acquire_target_position()
	var weight = 1.0 - pow(smoothing, delta)
	global_position = lerp(global_position, targetPosition, weight)

func acquire_target_position():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		targetPosition = players[0].global_position
