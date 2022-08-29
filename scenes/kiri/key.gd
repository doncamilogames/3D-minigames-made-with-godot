extends Area


export var _key = ""
var _player
func _ready():
	_player = get_tree().current_scene.find_node("player")
	
	if(_key != ""):
		var _material = load("res://scenes/kinematic/tile/plane22.tres")
		_material = _material.duplicate()
		_material.set_albedo(ColorN(_key))
		
		get_node("MeshInstance").set_surface_material(0,_material)
		
		
func _on_key_body_entered(body):
	if(body == _player):
		_player._on_key_body_entered(_key)
		queue_free()
