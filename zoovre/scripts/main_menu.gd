extends Control





func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mission_given.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/pause_menu.tscn")
