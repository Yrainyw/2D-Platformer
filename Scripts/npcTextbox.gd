extends Node2D

export(Array, String, MULTILINE) var texts
export var letters_per_second := 30.0
export var delay_between_lines := 1.0

onready var label = $PanelContainer/MarginContainer/Label

var current_index := 0
var is_typing := false
var typing_timer := 0.0
var full_text := ""
var waiting_timer := 0.0
var is_waiting := false

var has_played := false  # 新增:标记这段对话是否已经播放过

func _ready():
	$PanelContainer.visible = false
	label.autowrap = true

	$Area2D.connect("area_entered", self, "on_area_entered")
	$Area2D.connect("area_exited", self, "on_area_exited")

func on_area_entered(_area2d):
	if has_played:  # 已经播过就不再触发
		return
	$PanelContainer.visible = true
	current_index = 0
	start_typing(texts[current_index])

func on_area_exited(_area2d):
	if is_typing or is_waiting:
		# 玩家没等对话播完就离开了,直接结束这次对话(不算完整播放过,可选逻辑,见下方说明)
		close_dialogue()

func start_typing(text: String):
	full_text = text
	label.text = full_text
	label.visible_characters = 0
	is_typing = true
	typing_timer = 0.0

func _process(delta):
	if is_typing:
		typing_timer += delta
		var target_chars = int(typing_timer * letters_per_second)
		if target_chars != label.visible_characters:
			label.visible_characters = target_chars
			if target_chars >= full_text.length():
				label.visible_characters = -1
				is_typing = false
				is_waiting = true
				waiting_timer = 0.0
	elif is_waiting:
		waiting_timer += delta
		if waiting_timer >= delay_between_lines:
			is_waiting = false
			next_line()

func next_line():
	current_index += 1
	if current_index < texts.size():
		label.text = ""
		start_typing(texts[current_index])
	else:
		close_dialogue()
		has_played = true  # 全部说完,标记为已播放,以后不再触发

func close_dialogue():
	$PanelContainer.visible = false
	is_typing = false
	is_waiting = false
