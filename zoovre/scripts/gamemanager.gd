extends Node

var player: Node = null
var auto_cur_cam_id: int = 1
var cur_cam_node: SurveillanceCam = null
var caught: bool = false
var reset_cam: SurveillanceCam = null
var prog_bar: ProgressBar = null
var prog_bar_nmb: int = 0
var level_2: bool = false
var hideout: bool = false

func _ready() -> void:
	if level_2:
		cur_cam_node = $Camera3D

func _input(event):
	if event.is_action_pressed("1"):
		get_tree().change_scene_to_file("res://scenes/Level1.tscn")
		level_2 = false
		prog_bar_nmb = 0
		
	if event.is_action_pressed("2"):
		get_tree().change_scene_to_file("res://scenes/hideout.tscn")
		level_2 = false

	if event.is_action_pressed("3"):
		get_tree().change_scene_to_file("res://scenes/Level2.tscn")
		level_2 = true
