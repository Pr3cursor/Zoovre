extends CharacterBody3D


@export var move_speed = 5.0
@export var acceleration = 20.0

@onready var anim : AnimationPlayer = $raccoon.get_node("AnimationPlayer")

const JUMP_VELOCITY = 4.5
var cam: Camera3D
var cam_input_direction := Vector2.ZERO


func _ready() -> void:
	Gamemanager.player = self
	update_camera()
	#self.sig_caught.connect(_game_over)
	
func update_camera():
	if Gamemanager.cur_cam_node:
		cam = Gamemanager.cur_cam_node.get_node("Camera3D") as Camera3D

func _physics_process(delta: float) -> void:
	update_camera()
	cam_input_direction = Vector2.ZERO
	var raw_input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var forward := cam.global_transform.basis.z
	var right := cam.global_basis.x
	
	var move_direction := forward*raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	look_at(global_position + move_direction, Vector3.UP)
	velocity = velocity.move_toward(move_direction*move_speed,acceleration * delta)
	move_and_slide()
	
	if velocity.length() > 0 and !anim.assigned_animation == "barrel_roll":
		get_node("raccoon/AnimationPlayer").play("walk_animation")
	elif velocity.length() <= 0 or anim.assigned_animation == "barrel_roll":
		get_node("raccoon/AnimationPlayer").clear_queue()
	
	
func _input(event):
	if event.is_action_pressed("barrel_roll"):
		barrel_roll()
	
func game_over():
		#print("End")
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		
func barrel_roll():
	anim.play("barrel_roll")
	move_speed = 50
	await get_tree().create_timer(0.5).timeout
	move_speed = 5.0
