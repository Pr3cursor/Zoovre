extends Area3D

var player_in_range = false

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = !player_in_range
		print(player_in_range)

func pick_up():
	owner.queue_free()
	
	
func _physics_process(delta: float) -> void:
	if player_in_range and Input.is_action_pressed("interact"):
		pick_up()
