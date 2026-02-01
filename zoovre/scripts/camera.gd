class_name SurveillanceCam
extends Node3D
@export var camera_id :int = 0
#@export var camera_area3d: Node3D
@onready var camera: Camera3D = $Camera3D
var is_on : bool = false

func _ready() -> void:
	if camera_id == 1:
		camera.make_current()
		Gamemanager.cur_cam_node = self
		print(Gamemanager.cur_cam_node)
	#camera_area3d.sig_change_camera.connect(change_camera)
	#if camera_id == 1:
		#camera.current = true
		#Gamemanager.auto_cur_cam_id = 1
		#Gamemanager.cur_cam_node = self
		#is_on = true
		
	
func _process(delta: float) -> void:
	pass

#func change_camera(prev_cam_id, next_cam_id):
	#print("prev ", prev_cam_id)
	#print("next: ", next_cam_id)
	#if camera_id == next_cam_id:
		#camera.make_current()
		#Gamemanager.auto_cur_cam_id = camera_id
		#Gamemanager.cur_cam_node = self
		#print(Gamemanager.cur_cam_node)
		#is_on = true
		#print("Camera an ", camera_id)
	#elif camera_id == prev_cam_id:
		#camera.current = false
		#is_on = false
		#print("Camera aus ", camera_id)
	
	
#func change_to_next(goal_id,current_cam_id):
	#print(goal_id)
	#if camera_id == goal_id:
		#camera.make_current()
		#print(goal_id)
		#Gamemanager.auto_cur_cam_id == goal_id
#
#func change_to_prev(goal_id,current_cam_id):
	#print(goal_id)
	#if camera_id == goal_id:
		#camera.make_current()
		#print(goal_id)
		#Gamemanager.auto_cur_cam_id == goal_id
		
