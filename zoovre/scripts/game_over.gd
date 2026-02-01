extends Control



func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levelDesignTestScene.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
