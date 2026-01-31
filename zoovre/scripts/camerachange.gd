extends Node3D

signal sig_change_camera(old_cam_id, new_cam_id, current_cam_id)

@export var old_cam_id: int
@export var new_cam_id: int
var current_cam_id: int = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		#print(body)
		sig_change_camera.emit(old_cam_id,new_cam_id,current_cam_id)
