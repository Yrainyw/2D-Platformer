# GameCamera.gd
extends Camera2D

export(Color, RGB) var backgroundColor
export(float, 0.0, 0.999) var smoothing = 0.0001

var targetPosition := Vector2.ZERO
var targetNode = null  # 改成持有具体引用,而不是每帧搜索分组

func _ready():
	VisualServer.set_default_clear_color(backgroundColor)

func _process(delta):
	if targetNode != null and is_instance_valid(targetNode):
		targetPosition = targetNode.global_position
	var weight = 1.0 - pow(smoothing, delta)
	global_position = lerp(global_position, targetPosition, weight)

func set_target(node):
	targetNode = node
