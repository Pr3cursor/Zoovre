extends Node3D

@onready var animation_player: AnimationPlayer = $bin1/AnimationPlayer

@onready var label: Label = $Area3D/Node3D/SubViewport/Label
#@onready var marker_3d: Marker3D = $Marker3D
#@export var marker_3d: Marker3D
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
#
func _input(event: InputEvent) -> void:
	if player_inside and event.is_action_pressed("interact"):
		label.text = "press e to get out"
		Gamemanager.player.look_at(self.position)
		out_pos = Gamemanager.player.global_position
		emit_signal("player_bin_change")
		await get_tree().create_timer(2).timeout
		animation_player.play("expand")
		Gamemanager.player.visible = false
		player_inside = false


	elif Gamemanager.player.state == 3 and event.is_action_pressed("interact"):
		emit_signal("player_bin_change")
		Gamemanager.player.look_at(out_pos)
		await get_tree().create_timer(0.5).timeout
		Gamemanager.player.visible = true
		print("invis ", Gamemanager.player.visible)
		await get_tree().create_timer(1).timeout
		label.text = "press e to hide"
		animation_player.play("expand")
