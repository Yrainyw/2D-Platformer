extends KinematicBody2D

export var levelScenePath = "res://Levels/level_000.tscn"
export (PackedScene) var characterPlayerScene   # 新增：这个角色对应的完整Player场景

onready var animatedSprite = $AnimatedSprite
onready var animationPlayer = $AnimationPlayer


func _ready():
	$HoverArea.connect("mouse_entered", self, "on_mouse_entered")
	$HoverArea.connect("input_event", self, "on_input_event")
	animatedSprite.connect("animation_finished", self, "on_animation_finished")


func on_mouse_entered():
	if not $"/root/MenuState".characterSelectionEnabled:
		return
	animatedSprite.play("jump")
	animationPlayer.play("jump")


func on_animation_finished():
	if animatedSprite.animation == "jump":
		animatedSprite.play("idle")


func on_input_event(_viewport, event, _shape_idx):
	if not $"/root/MenuState".characterSelectionEnabled:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		$"/root/PlayerData".set_selected_character(characterPlayerScene)
		$"/root/ScreenTransitionManager".transition_to_scene(levelScenePath)
