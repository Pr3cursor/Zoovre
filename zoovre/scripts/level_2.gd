extends Node3D

@onready var painting_folder = $Art

func _ready():
	for child in painting_folder.get_children():
		var area := child.find_child("Area3D", true, false)
		if area and area.has_method("change_to_drawn"):
			area.change_to_drawn()
