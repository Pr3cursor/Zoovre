extends Node3D

var player_inside: bool = false
@onready var camera = $camera
func _ready():
	Gamemanager.hideout = false
	camera.find_child("Node2D").visible = false
	camera.find_child("Node2D").find_child("CanvasLayer").visible = false
	Gamemanager.player.light.visible = false

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true

func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false

func _input(event):
	if event.is_action_pressed("interact") and player_inside:
		get_tree().change_scene_to_file("res://scenes/Level2.tscn")
