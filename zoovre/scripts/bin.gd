extends Node3D

@onready var animation_player: AnimationPlayer = $bin1/AnimationPlayer

@onready var label: Label = $Area3D/Node3D/SubViewport/Label
@onready var marker_3d: Marker3D = $Marker3D
var player_inside: bool = false
var out_pos: Vector3

signal player_bin_change

func _ready():
	player_bin_change.connect(Gamemanager.player._on_player_in_bin)
func _on_area_3d_body_entered(body: Node3D):
	if body.is_in_group("player"):
		player_inside = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_inside = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_inside:
		player_inside = false
		label.text = "press e to get out"
		Gamemanager.player.look_at(marker_3d.position)
		emit_signal("player_bin_change")
		await get_tree().create_timer(2).timeout
		animation_player.play("expand")
		out_pos = Gamemanager.player.global_position
		Gamemanager.player.global_position = marker_3d.global_position
		#Gamemanager.player.scale *= 0.1
		
	elif event.is_action_pressed("interact") and Gamemanager.player.State.IN_BIN:
		emit_signal("player_bin_change")
		Gamemanager.player.position = out_pos
		await get_tree().create_timer(0.7).timeout
		Gamemanager.player.visible = true
		#Gamemanager.player.scale *= 10
		await get_tree().create_timer(1).timeout
		label.text = "press e to hide"
		animation_player.play("expand")
		print("test")
