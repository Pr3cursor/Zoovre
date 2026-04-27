extends CharacterBody3D

@onready var anim = $Character_2_1/AnimationPlayer
@onready var agent = $NavigationAgent3D


const SPEED = 4.0
const SMOOTHING_FACTOR = 0.1
const WANDER_RANGE = 20.0
const WAIT_AT_TARGET = 2.0

var update_timer := 0.0
var calibrating: bool = false

func _ready():
	set_random_target()
	
func _physics_process(delta):
	if agent.is_navigation_finished():
		start_calibration()
		return
	if calibrating:
		velocity.x = 0.0
		velocity.z = 0.0
		move_and_slide()
		if anim.current_animation != "Idle":
			anim.play("Idle")
		return
	move_to_agent(delta)
	
func start_calibration() -> void:
	if calibrating:
		return
	calibrating = true
	wait_and_pick_next_target()

func wait_and_pick_next_target() -> void:
	await get_tree().create_timer(WAIT_AT_TARGET).timeout
	calibrating = false
	set_random_target()
	
func set_random_target():
	var random_dir = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	var random_pos = global_position + (random_dir * randf_range(5.0, WANDER_RANGE))
	agent.target_position = random_pos
	
func move_to_agent(delta: float, speed: float = SPEED) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		move_and_slide()
		return

	if agent.is_navigation_finished():
		return

	var next_pos = agent.get_next_path_position()
	var dir = next_pos - global_position
	dir.y = 0.0
	dir = dir.normalized()

	if dir.length_squared() > 0.001:
		var current_forward := -global_transform.basis.z
		current_forward.y = 0.0
		current_forward = current_forward.normalized()

		var new_forward := current_forward.slerp(dir, 8.0 * delta).normalized()
		look_at(global_position + new_forward, Vector3.UP)

	velocity.x = dir.x * speed
	velocity.z = dir.z * speed
	move_and_slide()

	if anim.current_animation != "walk":
		anim.play("walk")
