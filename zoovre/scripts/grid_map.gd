extends GridMap


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_tile_type(pos: Vector3i) -> String:
	var item = get_cell_item(pos)
	var mesh_name = mesh_library.get_item_name(item)
	var type_map = {"grass": "grass", "dirt": "dirt"}  # Your custom mapping
	return type_map.get(mesh_name, "default")
