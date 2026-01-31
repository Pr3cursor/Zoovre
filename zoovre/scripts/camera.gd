extends Node3D

@export var camera_id : int
@export var camera_change: Area3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#camera_change.connect("camera_change", camera_change, change_camera())
	get_node("camera_change").body_entered.connect(change_camera)
	
func _process(delta: float) -> void:
	pass
	
func change_camera():
	pass
