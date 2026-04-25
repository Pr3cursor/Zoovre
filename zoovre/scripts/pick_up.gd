extends Area3D

var player_in_range = false
signal progress_update()
@export var ai_image: Node3D
@export var drawn_image: Node3D

var picked_up = false
var current_image = false 

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

	
	
func _physics_process(delta: float) -> void:
	if player_in_range and Input.is_action_pressed("interact"):
		Gamemanager.player.state = 7

func _on_image_picked_up():
	if current_image:
		drawn_image.visible = true

func _on_image_removed():
	print("got signal")
	if current_image:
		ai_image.hide()
