extends Node3D

@onready var painting_folder = $Art
@onready var camera_folder = $Cameras

func _ready():
	for child in painting_folder.get_children():
		var area := child.find_child("Area3D", true, false)
		if area and area.has_method("change_to_drawn"):
			area.change_to_drawn()
	Gamemanager.level_2 = true
	for child in camera_folder.get_children():
		var sprite_overlay := child.find_child("Node2D")
		if sprite_overlay:
			sprite_overlay.visible = false
			var control_overlay := sprite_overlay.find_child("CanvasLayer")
			if control_overlay:
				control_overlay.visible = false
