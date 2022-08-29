extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():

	for i in get_surface_material_count():
		mesh.surface_get_material(i).set_albedo("ffffff")
