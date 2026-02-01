extends CharacterBody3D

@onready var agent = $NavigationAgent3D
@onready var vision_ray = $RayCast3D

@export var patrol_points: Array[Node3D] = []
@export var speed_walk: float = 1.7
@export var speed_run: float = 3.0
@export var attack_range: float = 2.0
@export var investigate_wait_time: float = 4.0 
@export var patrol_wait_time: float = 3.0
@export var update_interval: float = 0.2

@onready var anim = $security.get_node("AnimationPlayer")

const UPDATE_TIME = 0.2
const SPEED = 150
const SMOOTHING_FACTOR = 0.1
const VIEW_ANGLE: float = 190.0

enum State {IDLE, PATROL, INVESTIGATE, CHASE, ATTACK, RETURN}
var state: State = State.IDLE

var target: Node3D
var patrol_index := 0
var patrol_timer := 0.0
var investigate_timer := 0.0
var update_timer := 0.0
var investigate_position: Vector3
var return_position: Vector3
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = Gamemanager.player
	_enter_state(State.IDLE if patrol_points.is_empty() else State.PATROL)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	_update_path(delta)
	
	match state:
		State.IDLE: _state_idle()
		State.PATROL: _state_patrol(delta)
		State.CHASE: _state_chase(delta)
		
		
	_looking()
	_apply_gravity(delta)
	move_and_slide()
	
func _go_to_next_patrol_point() -> void:
	patrol_index = ( patrol_index + 1 ) % patrol_points.size()
	agent.set_target_position(patrol_points[patrol_index].global_transform.origin)

func _move_towards(next_pos: Vector3, speed: float) -> void:
	var dir = (next_pos - global_transform.origin)
	dir.y = 0.0
	if is_zero_approx(dir.length()):
		velocity.x = lerp(velocity.x, 0.0, SMOOTHING_FACTOR)
		velocity.z = lerp(velocity.z, 0.0, SMOOTHING_FACTOR)
		return
	dir = dir.normalized()
	var current_facing = -global_transform.basis.z
	var new_dir = current_facing.slerp(dir, SMOOTHING_FACTOR).normalized()
	look_at(global_transform.origin + new_dir, Vector3.UP)
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed
	anim.play("walking")
	
func _stop_and_idle() -> void:
	velocity = Vector3.ZERO
	#anim.play("")
	
func _walk_to(next_pos: Vector3, speed: float) -> void:
	#anim.play("")
	_move_towards(next_pos, speed)
	
func _update_agent_target() -> void:
	target = Gamemanager.player
	match state:
		State.PATROL:
			if patrol_points.size() > 0:
				agent.set_target_position(patrol_points[patrol_index].global_transform.origin)
		State.INVESTIGATE:
			agent.set_target_position(investigate_position)
		State.CHASE:
			if target:
				agent.set_target_position(target.global_transform.origin)
		State.RETURN:
			agent.set_target_position(return_position)
	
func _update_path(delta):
	update_timer -= delta
	if update_timer <= 0.0:
		_update_agent_target()
		update_timer = update_interval

func _can_see_player() -> bool:
	return target and vision_ray.is_colliding() and vision_ray.get_collider() == target

func _looking() -> void:
	if not target:
		return
	
	var to_player = (target.global_transform.origin - global_transform.origin).normalized()
	var forward = -global_transform.basis.z
	var angle_deg = rad_to_deg(acos(clamp(forward.dot(to_player), -1.0, 1.0)))
	if angle_deg > VIEW_ANGLE * 0.5:
		return
	var ray_forward = -vision_ray.global_transform.basis.z
	var new_dir = ray_forward.slerp(to_player, SMOOTHING_FACTOR).normalized()
	vision_ray.look_at(vision_ray.global_transform.origin + new_dir, Vector3.UP)
	

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	else: 
		velocity.y = 0.0
		
func _enter_state(new_state: State) -> void:
	state = new_state
	match state:
		State.PATROL:
			patrol_timer = 0
			_go_to_next_patrol_point()
			
func _state_idle() -> void:
	if _can_see_player():
		_enter_state(State.CHASE)

func _state_patrol(delta: float) -> void:
	if agent.is_navigation_finished():
		if patrol_timer <= 0.0: 
			patrol_timer = patrol_wait_time
			_stop_and_idle()
		else:
			patrol_timer -= delta
			if patrol_timer <= 0.0:
				_go_to_next_patrol_point()
	else:
		_walk_to(agent.get_next_path_position(), speed_walk)

	if _can_see_player():
		_enter_state(State.CHASE)
		
func _state_chase(delta: float) -> void:
	if not target:
		_enter_state(State.RETURN)
		return
	_walk_to(agent.get_next_path_position(), speed_run)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Gamemanager.player.game_over()
