extends Node3D

@onready var label: Label = $Area3D/Node3D/SubViewport/Label
@onready var marker_3d: Marker3D = $Marker3D
var player_inside: bool = false

func _on_area_3d_body_entered(body: Node3D):
	if body.is_in_group("player"):
		player_inside = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_inside = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_inside:
		Gamemanager.player.global_position = marker_3d.global_position
		Gamemanager.player.scale *= 0.1
