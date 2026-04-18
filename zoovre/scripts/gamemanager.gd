extends Node

var player: Node = null
var auto_cur_cam_id: int = 1
var cur_cam_node: SurveillanceCam = null
var caught: bool = false
var reset_cam: SurveillanceCam = null
var prog_bar: ProgressBar = null
var prog_bar_nmb: int = 0
