extends Spatial


export var _type = ""
func _ready():
	if(_type != ""):

		var arraybody = [get_node("Armature/Bone/chest"),get_node("Armature/Bone/Bone004/Bone005/rw1"),get_node("Armature/Bone/Bone004/rw2"),get_node("Armature/Bone/Bone002/Bone003/lw1"),get_node("Armature/Bone/Bone002/lw2")]
		var _materialbody = load("res://scenes/kiri/bird1.tres")
		_materialbody = _materialbody.duplicate()
		var _materialhead = load("res://scenes/kiri/bird1face.tres")
		_materialhead = _materialhead.duplicate()
		_materialbody.set_albedo("ff77cd")
		_materialhead.set_albedo("ff77cd")
		for i in arraybody:
			i.set_surface_material(0,_materialbody)
		get_node("Armature/Bone/Bone001/head").set_surface_material(2,_materialbody)
		get_node("Armature/Bone/Bone001/head").set_surface_material(0,_materialhead)
		
			#get_node("base").set_surface_material(0,_material)
	get_node("AnimationPlayer").play("fligh")
