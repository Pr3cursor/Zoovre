extends Node3D

@export var camera_id : int
@export var camera_change_next: Node3D
@export var camera_change_prev: Node3D
@onready var camera = $Camera3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera_change_next.sig_change_camera.connect(change_to_next)
	camera_change_prev.sig_change_camera.connect(change_to_prev)
	if camera_id == 1:
		camera.current = true
	Gamemanager.auto_cur_cam_id = 1
	
func _process(delta: float) -> void:
	pass
	
func change_to_next(goal_id,current_cam_id):
	print(goal_id)
	if camera_id == goal_id:
		camera.make_current()
		print(goal_id)
		Gamemanager.auto_cur_cam_id == goal_id

func change_to_prev(goal_id,current_cam_id):
	print(goal_id)
	if camera_id == goal_id:
		camera.make_current()
		print(goal_id)
		Gamemanager.auto_cur_cam_id == goal_id
		
