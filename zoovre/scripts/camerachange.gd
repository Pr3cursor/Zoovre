extends Node3D


#@warning_ignore("unused_signal")
#signal sig_change_camera(prev_cam_id, next_cam_id)

#@export var prev_cam_id: int
#@export var next_cam_id: int

@export var prev_cam: SurveillanceCam
@export var next_cam: SurveillanceCam

var current_cam_id: int = 1
var switch = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if switch:
			next_cam.camera.make_current()
			prev_cam.camera.current = false
			Gamemanager.cur_cam_node = next_cam
		else:
			prev_cam.camera.make_current()
			next_cam.camera.current = false
			Gamemanager.cur_cam_node = prev_cam
		
		switch = !switch



	#print("hi")
	#if body.is_in_group("player"):
		#if switch:
			##print("prev ", prev_cam_id)
			##print("next: ", next_cam_id)
			#sig_change_camera.emit(prev_cam_id, next_cam_id)
			#switch = false
		#else:
			##print("prev ", next_cam_id)
			##print("next: ", prev_cam_id)
			#sig_change_camera.emit(next_cam_id,prev_cam_id)
			#switch = true


#func _on_body_entered(body: Node3D) -> void:
	#if body.is_in_group("player"):
		##print(body)
		#sig_change_camera.emit(old_cam_id,new_cam_id,current_cam_id)


#func _on_area_3d_body_entered(body: Node3D) -> void:
	#if body.is_in_group("player")and Gamemanager.auto_cur_cam_id == old_cam_id:
		#sig_change_camera.emit(new_cam_id,current_cam_id)
#
#func _on_area_3d_2_body_entered(body: Node3D) -> void:
	#if body.is_in_group("player") and Gamemanager.auto_cur_cam_id == new_cam_id:
		#sig_change_camera.emit(old_cam_id,current_cam_id)
