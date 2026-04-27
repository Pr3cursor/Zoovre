extends Area3D

var player_in_range = false
signal progress_update()
@export var ai_image: Node3D
@export var drawn_image: Node3D

var picked_up = false
var changed_image = false
var current_image = false 

func change_to_drawn():
	ai_image.visible = false
	drawn_image.visible = true

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = !player_in_range
		current_image = true
		#print(player_in_range)
		progress_update.emit()

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		current_image = false


func pick_up():
	owner.queue_free()
	Gamemanager.prog_bar_nmb += 1
	#progress_update.emit()
	Gamemanager.player.game_won()

func _input(event):
	if event.is_action_pressed("interact") and player_in_range and !picked_up:
		Gamemanager.player.state = 7
		print("changing state to 7")

	if event.is_action_pressed("interact") and player_in_range and picked_up and !changed_image:
		Gamemanager.player.state = 8
		print("changing state to ", Gamemanager.player.state)
		changed_image = true


func _on_image_picked_up():
	if current_image and picked_up:
		await get_tree().create_timer(1).timeout
		drawn_image.visible = true
		
func _on_image_removed():
	if current_image and !picked_up:
		await get_tree().create_timer(1).timeout
		ai_image.hide()
		picked_up = true
