extends Label

var time_passed := 0.0

@onready var label = $TimeLabel

func _process(delta):
	time_passed += delta

	var hours = int(time_passed / 3600)
	var minutes = int(time_passed / 60) % 60
	var seconds = int(time_passed) % 60
	var milliseconds = int((time_passed - int(time_passed)) * 100)

	text = "%02d:%02d:%02d:%02d" % [hours, minutes, seconds, milliseconds]
	
