extends CharacterBody3D


@export var move_speed = 5.0
@export var acceleration = 20.0
@onready var animation_tree: AnimationTree = $AnimationTree

@onready var anim : AnimationPlayer = $raccoon_3/AnimationPlayer

signal added_painting
signal removed_painting
@onready var painting_folder = $"../Art"

const JUMP_VELOCITY = 4.5
var cam: Camera3D
var cam_input_direction := Vector2.ZERO
const EPSILON = 0.01

var can_move: bool = true

enum State {IDLE, MOVE, MOVE_IN_BIN, IN_BIN, MOVE_OUT_BIN, CAUGHT, ROLL, TAKE_PAINTING, PUT_PAINTING}
var state: State

func _ready() -> void:
	Gamemanager.player = self
	update_camera()
	animation_tree.active = true
	_enter_state(State.IDLE)
	
	for child in painting_folder.get_children():
		var area := child.find_child("Area3D", true, false)
		if area and area.has_method("_on_image_picked_up"):
			added_painting.connect(area._on_image_picked_up)
		if area and area.has_method("_on_image_removed"):
			removed_painting.connect(area._on_image_removed)

func _enter_state(new_state: State) -> void:
	state = new_state

func _update_agent_target() -> void:
	match state:
		State.IDLE:
			animation_tree["parameters/conditions/is_idle"] = true
			animation_tree["parameters/conditions/is_moving"] = false
			state_idle()
		State.MOVE:
			animation_tree["parameters/conditions/is_idle"] = false
			animation_tree["parameters/conditions/is_moving"] = true
			state_move()
		State.CAUGHT:
			animation_tree["parameters/conditions/is_caught"] = true
		State.MOVE_IN_BIN:
			animation_tree["parameters/conditions/is_jumped"] = true
			animation_tree["parameters/conditions/is_idle"] = false
			animation_tree["parameters/conditions/is_moving"] = false
			can_move = false
			#print("entered state move_in_bin")
		State.MOVE_OUT_BIN:
			animation_tree["parameters/conditions/is_jumped_out"] = true
			animation_tree["parameters/conditions/is_jumped"] = false
			animation_tree["parameters/conditions/is_idle"] = false
			animation_tree["parameters/conditions/is_moving"] = false
			#print("entered state move_out_bin")
		State.ROLL:
			animation_tree["parameters/conditions/is_idle"] = false
			animation_tree["parameters/conditions/is_moving"] = false
			animation_tree["parameters/conditions/roll"] = true
		State.TAKE_PAINTING:
			animation_tree["parameters/conditions/is_idle"] = false
			animation_tree["parameters/conditions/is_moving"] = false
			animation_tree["parameters/conditions/remove_painting"] = true
			can_move = false
			#print("TAKE_PAINTING: ", state)

		State.PUT_PAINTING:
			animation_tree["parameters/conditions/is_idle"] = false
			animation_tree["parameters/conditions/is_moving"] = false
			animation_tree["parameters/conditions/remove_painting"] = false
			animation_tree["parameters/conditions/add_painting"] = true
			can_move = false

func update_camera():
	if Gamemanager.cur_cam_node:
		cam = Gamemanager.cur_cam_node.get_node("Camera3D") as Camera3D

func _physics_process(delta: float) -> void:
	update_camera()
	_update_agent_target()
	if can_move:
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
	else:
		velocity = Vector3.ZERO

func state_move():
	if velocity == Vector3.ZERO:
		_enter_state(State.IDLE)

func state_idle():
	if velocity > Vector3.ZERO:
		_enter_state(State.MOVE)

func _on_player_in_bin():
	if state == 3:
		_enter_state(State.MOVE_OUT_BIN)
	else:
		_enter_state(State.MOVE_IN_BIN)

func _input(event):
	if event.is_action_pressed("barrel_roll") and state != 6:
		barrel_roll()
	if event.is_action_pressed("reset"):
		reset()

func game_won():
		if Gamemanager.prog_bar_nmb >= 6:
			get_tree().change_scene_to_file("res://scenes/mission_accomplished.tscn")

func game_over():
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func barrel_roll():
	_enter_state(State.ROLL)
	move_speed = 20
	
func reset():
	self.position = Vector3(-157.159,0,32.693)
	Gamemanager.cur_cam_node = Gamemanager.reset_cam
	Gamemanager.reset_cam.reset_make_current()
	print(Gamemanager.cur_cam_node, Gamemanager.reset_cam)


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "jump_001":
		_enter_state(State.IN_BIN)
	if anim_name == "jump_out":
		animation_tree["parameters/conditions/is_jumped_out"] = false
		can_move = true
		_enter_state(State.IDLE)
	if anim_name == "barrel_roll":
		animation_tree["parameters/conditions/roll"] = false
		animation_tree["parameters/conditions/is_idle"] = true
		move_speed = 5.0
		velocity = Vector3.ZERO
		_enter_state(State.IDLE)
	if anim_name == "add_painting_1":
		animation_tree["parameters/conditions/add_painting"] = false
		animation_tree["parameters/conditions/is_idle"] = true
		_enter_state(State.IDLE)
		can_move = true
	if anim_name == "remove_painting_1":
		animation_tree["parameters/conditions/remove_painting"] = false
		animation_tree["parameters/conditions/is_idle"] = true
		_enter_state(State.IDLE)
		can_move =  true


func _on_animation_tree_animation_started(anim_name):
	if anim_name == "add_painting_1":
		emit_signal("added_painting")
	if anim_name == "remove_painting_1":
		emit_signal("removed_painting")
