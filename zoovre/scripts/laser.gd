extends RayCast3D

@onready var beam_mesh = $BeamMesh
@onready var end_particles = $EndParticles
@onready var beam_particles = $BeamParticles
@onready var death_area: Area3D = $DeathArea
@onready var death_shape: CollisionShape3D = $DeathArea/DeathShape
@onready var toggle_timer: Timer = $Timer

var tween: Tween
var beam_radius: float = 0.03
var laser_active := false

func _ready() -> void:
	death_area.monitoring = true
	death_area.monitorable = true
	death_shape.disabled = true
	death_area.body_entered.connect(_on_death_area_body_entered)
	toggle_timer.timeout.connect(_on_toggle_timer_timeout)
	toggle_timer.start()

func _process(delta):
	var cast_point
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		
		beam_mesh.mesh.height = cast_point.y
		beam_mesh.position.y = cast_point.y/2
		
		death_shape.shape.height = abs(cast_point.y)
		death_shape.position.y = cast_point.y / 2.0
		#print(death_shape.shape.height)
		end_particles.position.y = cast_point.y
		
		beam_particles.position.y = cast_point.y/2
		
		var particle_amount = snapped(abs(cast_point.y)*50,1)
		
		if particle_amount > 1:
			beam_particles.amount = particle_amount
		else:
			beam_particles.amount = 1
			
		beam_particles.process_material.set_emission_box_extents(Vector3(beam_mesh.mesh.top_radius, abs(cast_point.y)/2,beam_mesh.mesh.top_radius))

func _on_toggle_timer_timeout() -> void:
	if laser_active:
		deactivate(1.0)
	else:
		activate(1.0)

func activate(time: float):
	laser_active = true
	death_shape.disabled = false
	death_area.monitoring = true
	tween = get_tree().create_tween()
	visible = true
	beam_particles.emitting = true
	end_particles.emitting = true
	death_area.visible = true
	tween.set_parallel(true) 
	tween.tween_property(beam_mesh.mesh,"top_radius",beam_radius, time)
	tween.tween_property(beam_mesh.mesh,"bottom_radius",beam_radius, time)
	tween.tween_property(beam_particles.process_material,"scale_min",1,time)
	tween.tween_property(end_particles.process_material,"scale_min",1,time)
	await tween.finished
	
func deactivate(time: float):
	laser_active = false
	
	tween = get_tree().create_tween()
	tween.set_parallel(true) 
	tween.tween_property(beam_mesh.mesh,"top_radius",0.0, time)
	tween.tween_property(beam_mesh.mesh,"bottom_radius",0.0, time)
	tween.tween_property(beam_particles.process_material,"scale_min",0.0,time)
	tween.tween_property(end_particles.process_material,"scale_min",0.0,time)
	await tween.finished
	visible = false
	beam_particles.emitting = false
	end_particles.emitting = false
	death_area.visible = false
	death_shape.disabled = true
	death_area.monitoring = false
	
func _on_death_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and laser_active:
		print("entered")
		Gamemanager.player.game_won()
