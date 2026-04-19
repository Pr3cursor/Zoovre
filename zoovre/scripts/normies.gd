extends CharacterBody3D

#@onready var anim = 
@onready var agent = $NavigationAgent3D

const UPDATE_TIME = 0.2
const SPEED = 5.0
const SMOOTHING_FACTOR = 0.1
const WANDER_RANGE = 20.0

var update_timer := 0.0

func _ready():
	set_random_target()
	
	
	
func _physics_process(delta):
	if agent.is_navigation_finished():
		set_random_target()
		return
	move_to_agent(delta)

func set_random_target():
	var random_dir = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	var random_pos = global_position + (random_dir * randf_range(5.0, WANDER_RANGE))
	agent.target_position = random_pos
	
func move_to_agent(delta: float, speed: float = SPEED):
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		move_and_slide()
		return

	if agent.is_navigation_finished():
		return
	
	var next_pos = agent.get_next_path_position()
	var dir = (next_pos - global_position).normalized()
	dir.y = 0
	
	var current_facing = -global_transform.basis.z
	var new_dir = current_facing.slerp(dir, SMOOTHING_FACTOR).normalized()
	look_at(global_position + new_dir, Vector3.UP)
	
	velocity = velocity.lerp(dir * speed, SMOOTHING_FACTOR)
	move_and_slide()
	$Character_2_1/AnimationPlayer.play("walk")
