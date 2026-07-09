extends CanvasLayer

onready var playButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PlayButton
onready var optionsButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionsButton
onready var quitButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton
onready var panel = $MarginContainer/PanelContainer
onready var disappearAnimationPlayer = $DisappearAnimationPlayer
onready var selectCharacterLabel = $SelectCharacterLabel   # 新增


func _ready():
	playButton.connect("pressed", self, "on_play_pressed")
	quitButton.connect("pressed", self, "on_play_quit")
	disappearAnimationPlayer.connect("animation_finished", self, "on_disappear_finished")


func on_play_pressed():
	disappearAnimationPlayer.play("default")


func on_disappear_finished(_anim_name):
	panel.visible = false
	$MarginContainer.visible = false
	selectCharacterLabel.visible = true   # 新增：Panel消失后才显示提示文字
	$"/root/MenuState".characterSelectionEnabled = true


func on_play_quit():
	get_tree().quit()
