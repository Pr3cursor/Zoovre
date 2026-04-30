extends Node2D



func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Level2.tscn")
	



func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
