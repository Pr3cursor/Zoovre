extends Node3D

@export var speed := Vector3(0,50,0)
var back = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var y_rotation_radians = rotation_degrees.y
	if y_rotation_radians < 91 and back == false:
		rotation_degrees += speed * delta
		if y_rotation_radians > 90:
			back = true
	elif back == true:
		rotation_degrees -= speed * delta
		if y_rotation_radians < -90:
			back = false
