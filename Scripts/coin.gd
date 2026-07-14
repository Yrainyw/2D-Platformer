extends Node2D

func _ready():
	$Area2D.connect("area_entered", self, "on_area_entered")
	
	
func on_area_entered(_area2d):
	#print("Coin at ", global_position, " collected by ", _area2d.get_path())
	$AnimationPlayer.play("pickup")
	call_deferred("disable_pickup")
	
	var baseLevel = get_tree().get_nodes_in_group("base_level")[0]
	baseLevel.coin_collected()
	$RandomAudioStreamPlayer1.play()
	$RandomAudioStreamPlayer2.play()
		
		
func disable_pickup():
	$Area2D/CollisionShape2D.disabled = true
