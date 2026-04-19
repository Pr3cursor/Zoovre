extends Node3D

@onready var animation_player: AnimationPlayer = $bin1/AnimationPlayer

@onready var label: Label = $Area3D/Node3D/SubViewport/Label
@onready var marker_3d: Marker3D = $Marker3D
var player_inside: bool = false
var out_pos: Vector3

func _on_area_3d_body_entered(body: Node3D):
	if body.is_in_group("player"):
		player_inside = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_inside = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_inside:
		Gamemanager.player.can_move = false
		player_inside = false
		label.text = "press e to get out"
		Gamemanager.player.is_in_bin = true
		Gamemanager.player.look_at(marker_3d.position)
		await get_tree().create_timer(2).timeout
		animation_player.play("expand")
		out_pos = Gamemanager.player.global_position
		Gamemanager.player.global_position = marker_3d.global_position
		Gamemanager.player.scale *= 0.1

		
		
	elif event.is_action_pressed("interact") and !player_inside and !Gamemanager.player.can_move:
		#var dir = Gamemanager.player.global_position.normalized()
		#Gamemanager.player.global_position = out_pos + dir
		#Gamemanager.player.look_at(out_pos)
		Gamemanager.player.visible = false
		Gamemanager.player.position = out_pos
		Gamemanager.player.is_in_bin = false
		await get_tree().create_timer(0.7).timeout
		Gamemanager.player.visible = true
		Gamemanager.player.scale *= 10
		Gamemanager.player.exited_bin = true
		await get_tree().create_timer(1).timeout
		Gamemanager.player.can_move = true
		label.text = "press e to hide"
		animation_player.play("expand")
