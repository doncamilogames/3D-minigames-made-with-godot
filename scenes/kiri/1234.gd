extends Spatial

var step = 0
export var key = ""
var _player
func _ready():
	_player = get_tree().current_scene.find_node("player")
	_updatecolors()


func _updatecolors():
#	var albedomat
	if(step == 0):
		get_node("1/MeshInstance").get_active_material(0).set_albedo(ColorN("white"))
		get_node("2/MeshInstance").get_active_material(0).set_albedo(ColorN("white"))
		get_node("3/MeshInstance").get_active_material(0).set_albedo(ColorN("white"))
		get_node("4/MeshInstance").get_active_material(0).set_albedo(ColorN("white"))
	if(step == 1):
		get_node("1/MeshInstance").get_active_material(0).set_albedo(ColorN(key))
		get_node("2/MeshInstance").get_active_material(0).set_albedo(ColorN("white"))
		get_node("3/MeshInstance").get_active_material(0).set_albedo(ColorN("white"))
		get_node("4/MeshInstance").get_active_material(0).set_albedo(ColorN("white"))
	if(step == 2):
		get_node("1/MeshInstance").get_active_material(0).set_albedo(ColorN(key))
		get_node("2/MeshInstance").get_active_material(0).set_albedo(ColorN(key))
		get_node("3/MeshInstance").get_active_material(0).set_albedo(ColorN("white"))
		get_node("4/MeshInstance").get_active_material(0).set_albedo(ColorN("white"))
	if(step == 3):
		get_node("1/MeshInstance").get_active_material(0).set_albedo(ColorN(key))
		get_node("2/MeshInstance").get_active_material(0).set_albedo(ColorN(key))
		get_node("3/MeshInstance").get_active_material(0).set_albedo(ColorN(key))
		get_node("4/MeshInstance").get_active_material(0).set_albedo(ColorN("white"))


	if(step == 4):
		get_node("1/MeshInstance").get_active_material(0).set_albedo(ColorN(key))
		get_node("2/MeshInstance").get_active_material(0).set_albedo(ColorN(key))
		get_node("3/MeshInstance").get_active_material(0).set_albedo(ColorN(key))
		get_node("4/MeshInstance").get_active_material(0).set_albedo(ColorN(key))
func _on_1_body_entered(body):
	if(step == 0):
		step = 1
		_updatecolors()
	else :
		step = 1
		_updatecolors()


func _on_2_body_entered(body):
	if(step == 1):
		step = 2
		_updatecolors()
	else :
		step = 0
		_updatecolors()


func _on_3_body_entered(body):
	if(step == 2):
		step = 3
		_updatecolors()
	else :
		step = 0
		_updatecolors()


func _on_4_body_entered(body):
	if(step == 3):
		_player._on_key_body_entered(key)
		step = 4
		_updatecolors()
	else :
		step = 0
		_updatecolors()
