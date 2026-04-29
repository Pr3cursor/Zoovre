extends CanvasLayer


@onready var label: Label = $TimeLabel
@onready var cam_label: Label = $CamLabel
@onready var progress_bar: TextureProgressBar = $TextureProgressBar
@onready var progress_label: Label = $ProgressLabel


var time_passed := 0.0

func _process(delta):
	time_passed += delta

	var hours = int(time_passed / 3600)
	var minutes = int(time_passed / 60) % 60
	var seconds = int(time_passed) % 60
	var milliseconds = int((time_passed - int(time_passed)) * 100)

	label.text = "%02d:%02d:%02d:%02d" % [hours, minutes, seconds, milliseconds]
	
	cam_label.text = "CAM " + str(Gamemanager.auto_cur_cam_id)
	progress_label.text = str(Gamemanager.prog_bar_nmb) + "/6"
	
	progress_bar.value = Gamemanager.prog_bar_nmb
	
	
