extends Node

var player: Node = null
var auto_cur_cam_id: int = 1
var cur_cam_node: SurveillanceCam = null
var caught: bool = false

func reload_level():
	get_tree().reload_current_scene()
