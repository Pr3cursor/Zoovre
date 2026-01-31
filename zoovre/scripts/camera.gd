extends Node3D

@export var camera_id : int
@export var camera_change: Area3D
@onready var camera = $Camera3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if camera_change == null:
		print("no changed camera!")
		return
	camera_change.sig_change_camera.connect(_on_change_camera)
	if camera_id == 1:
		camera.current = true
	
func _process(delta: float) -> void:
	pass
	
func _on_change_camera(old_cam_id,new_cam_id,current_cam_id):
	#print(current_cam_id)
	if camera_id != current_cam_id:
		camera.make_current()
		current_cam_id = camera_id
		print("changed camera: ", current_cam_id)
