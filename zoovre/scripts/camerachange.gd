extends Node3D

@export var prev_cam: SurveillanceCam
@export var next_cam: SurveillanceCam

var locked: bool = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	
	if locked:
		return
	
	locked = true

	if Gamemanager.cur_cam_node == prev_cam:
		next_cam.camera.make_current()
		Gamemanager.cur_cam_node = next_cam
		Gamemanager.auto_cur_cam_id = next_cam.camera_id

	elif Gamemanager.cur_cam_node == next_cam:
		prev_cam.camera.make_current()
		Gamemanager.cur_cam_node = prev_cam
		Gamemanager.auto_cur_cam_id = prev_cam.camera_id

	await get_tree().create_timer(0.15).timeout
	locked = false
