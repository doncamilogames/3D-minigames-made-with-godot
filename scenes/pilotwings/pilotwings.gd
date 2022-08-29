extends Spatial

var _mode = ""
var rings = 0
var targets = 0
var started = 0
var _cammode = 1
var gametime = 0.0
var minutes
var second
func _ready():
	_mode = Global.pilotswins.modeselected
	Global._updateadjworldenv()
	started = 1
	get_node("plane").set_physics_process(true)
	get_node("plane").set_process(true)
	_updatehud()
	set_process(true)

	if( _mode == "rings"):
		get_node("menu/Label").set_text("Rings : ")
		get_node("targets").queue_free()
		get_node("plane/pointer").visible = false
		get_node("plane/Control/shoot").visible = false
		
	if( _mode == "targets"):
		get_node("menu/Label").set_text("Targets : ")
		get_node("rings").queue_free()

func _playsound(what):
	var newsound = "res://asset/sounds/" + what
	get_node("sound").set_stream(load(newsound))
	get_node("sound").play()

func _updatehud():
	if( _mode == "rings"):
		get_node("menu/Label/amount").set_text(str(rings))
		if(rings == 10):
			_endgame()
			

	if( _mode == "targets"):
		get_node("menu/Label/amount").set_text(str(targets))
		if(targets == 10):
			_endgame()

func _process(delta):
	gametime += delta
	get_node("menu/time/amount").set_text( str(floor(gametime/60)) +":" + str(floor(fmod(gametime,60))))


func _endgame():
	set_process(false)
	if( _mode == "rings"):
		if(name == "pilotwings1"):
			Global.pilotswins.timerings[1] = gametime
			Global.pilotswins.scorerings[1] = 10
		if(name == "pilotwings2"):
			Global.pilotswins.timerings[2] = gametime
			Global.pilotswins.scorerings[2] = 10
		if(name == "pilotwings3"):
			Global.pilotswins.timerings[3] = gametime
			Global.pilotswins.scorerings[3] = 10
	if( _mode == "targets"):
		if(name == "pilotwings1"):
			Global.pilotswins.timetargets[1] = gametime
			Global.pilotswins.scoretargets[1] = 10
		if(name == "pilotwings2"):
			Global.pilotswins.timetargets[2] = gametime
			Global.pilotswins.scoretargets[2] = 10
		if(name == "pilotwings3"):
			Global.pilotswins.timetargets[3] = gametime
			Global.pilotswins.scoretargets[3] = 10

	get_node("plane")._win()
	Global._savegame()
	get_node("music").set_stream(load("res://asset/sounds/greatbonus.ogg"))
	get_node("music").set_volume_db(6.0)
	get_node("music").play()
	get_node("menu").visible = false
	get_node("plane/speed").visible = false
	get_node("plane/fuel").visible = false
	get_node("plane/Control").visible = false

func _changecam():
	if(_cammode == 1):
		_cammode = 2
		get_node("plane/Mesh/MeshInstance/Camera").current = true
		get_node("plane/SpringArm/Camera").current = false
#		get_node("plane/Mesh/MeshInstance/RayCast").rotation_degrees.z = -10
		return

	if(_cammode == 2):
		_cammode = 1
		get_node("plane/Mesh/MeshInstance/Camera").current = false
		get_node("plane/SpringArm/Camera").current = true
#		get_node("plane/Mesh/MeshInstance/RayCast").rotation_degrees.z = -5
		return
	

	
func _on_quit_pressed():
		get_tree().change_scene("res://scenes/pilotwings/pilotwingsmenu.tscn")

func _on_camera_pressed():
	_changecam()
