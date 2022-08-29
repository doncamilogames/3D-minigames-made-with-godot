extends Spatial

var started = 0
var level = 1
var _level = 1
var _mode = "static"
var playerspeed = 4
var obstaclespeed = 2
var lifes = 3
var currentscore = 0
var meshplayer
var meshtube
var _tubemat
func _ready():
	_level = Global.hyperdecagon.levelselected
	_mode = Global.hyperdecagon.modeselected
	_updatehud()
	Global._updateadjworldenv()
	meshplayer = get_node("Spatial/Area/MeshInstance")
	meshtube = get_node("tube")
	if _mode == "static":
		get_node("Menu/score/amount").set_text(str(Global.hyperdecagon.scorestatic[_level]))
	if _mode == "dynamic":
		get_node("Menu/score/amount").set_text(str(Global.hyperdecagon.scoredynamic[_level]))


	if _level == 1 :
		_tubemat = load("res://scenes/tube/tube1.tres")
		get_node("music").play()
	if _level == 2 :
		_tubemat = load("res://scenes/tube/tube2.tres")
		get_node("Animcolor").playback_speed = 4.0
		get_node("music").set_stream(load("res://asset/sounds/moto1.ogg"))
		get_node("music").play()
	if _level == 3 :
		_tubemat = load("res://scenes/tube/tube3.tres")
		get_node("Animcolor").playback_speed = 16.0
		get_node("music").set_stream(load("res://asset/sounds/kuru2.ogg"))
		get_node("music").play()
	get_node("tube").set_surface_material(0,_tubemat)
	
	
		
		
func _updatehud():
	if(lifes <= 0):
		get_node("Menu/restart").visible = true
		get_node("Menu/menu").visible = true
		get_node("tube/obstaclespawner").set_physics_process(false)
		started = 0 
		get_node("Menu").visible = true
		get_node("HUD").rect_position = Vector2(0,600)
		get_node("HUD/score").rect_position = Vector2(751,-590)
		for i in get_node("tube/obstaclespawner").get_children():
				i.queue_free()
		get_node("Timer").stop()
		get_node("tube/obstaclespawner").childs.clear()
		get_node("music").stop()
				
		if _mode == "static":
			if currentscore > Global.hyperdecagon.scorestatic[_level] :
				print("new score")
				Global.hyperdecagon.scorestatic[_level] = currentscore
				get_node("Menu/score/Label").visible = true
				get_node("Menu/score/Label/AnimationPlayer").play("New Anim")
			if _level == 1 :
				if currentscore >= 100:
					Global.hyperdecagon.trophies[0] = 1
				if currentscore >= 120:
					Global.hyperdecagon.trophies[6] = 1
			if _level == 2 :
				if currentscore >= 85:
					Global.hyperdecagon.trophies[1] = 1
				if currentscore >= 110:
					Global.hyperdecagon.trophies[7] = 1
			if _level == 3 :
				if currentscore >= 75:
					Global.hyperdecagon.trophies[2] = 1
				if currentscore >= 100:
					Global.hyperdecagon.trophies[8] = 1
		if _mode == "dynamic":
			if currentscore > Global.hyperdecagon.scoredynamic[_level] :
				Global.hyperdecagon.scoredynamic[_level] = currentscore
				get_node("Menu/score/Label").visible = true
				get_node("Menu/score/Label/AnimationPlayer").play("New Anim")
			if _level == 1 :
				if currentscore >= 100:
					Global.hyperdecagon.trophies[3] = 1
				if currentscore >= 140:
					Global.hyperdecagon.trophies[9] = 1
			if _level == 2 :
				if currentscore >= 85:
					Global.hyperdecagon.trophies[4] = 1
				if currentscore >= 120:
					Global.hyperdecagon.trophies[10] = 1
			if _level == 3 :
				if currentscore >= 75:
					Global.hyperdecagon.trophies[5] = 1
				if currentscore >= 110:
					Global.hyperdecagon.trophies[11] = 1

		Global._savegame()

	get_node("HUD/score").set_text("Score : "+ str(currentscore))
	get_node("HUD/lifes").set_text("Lifes : "+ str(lifes))
	if(_mode == "static"):
		get_node("Menu/score/amount").set_text(str(Global.hyperdecagon.scorestatic[_level]))
		get_node("Animtube").stop()
	if(_mode == "dynamic"):
		get_node("Menu/score/amount").set_text(str(Global.hyperdecagon.scoredynamic[_level]))
		get_node("Animtube").play("turn")


	level = (ceil(currentscore / 10) + 1 )
	var waitimer = 1.5 - (level / 5)
	if(waitimer < 0.3):
		waitimer = 0.3
	get_node("Timer").wait_time = waitimer
	var speedtube = level
# warning-ignore:return_value_discarded
	min(speedtube,9.0)
	get_node("Animtube2").playback_speed = max(level,1.0)
	



func _physics_process(delta):
	if(started == 1):
		if(Input.is_action_pressed("ui_left")  == true or get_node("HUD/L").is_pressed() == true or Input.get_joy_axis(0,JOY_ANALOG_LX) < -0.7):
			get_node("Spatial").rotation_degrees.z -= playerspeed
			meshplayer.rotation_degrees.x = lerp(meshplayer.rotation_degrees.x, 45, delta * 20)
			
			
		elif(Input.is_action_pressed("ui_right")  == true or get_node("HUD/R").is_pressed() == true or Input.get_joy_axis(0,JOY_ANALOG_LX) > 0.7):
			get_node("Spatial").rotation_degrees.z += playerspeed
			meshplayer.rotation_degrees.x = lerp(meshplayer.rotation_degrees.x, -45, delta * 20)
			
			
		else:
			meshplayer.rotation_degrees.x = lerp(meshplayer.rotation_degrees.x, 0, delta * 100)

func _on_Back_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/tube/tubemenu.tscn")


func _on_Start_pressed():
	get_node("tube/obstaclespawner")._on_Timer_timeout()
	get_node("Menu").visible = false
	get_node("HUD").rect_position = Vector2(0,0)
	level = 1
	started = 1
	get_node("tube/obstaclespawner").set_physics_process(true)
	_updatehud()
#	get_node("music").play()

func _on_Area_body_entered(body):
	if(body.get_parent().name == "obstaclespawner"):
		get_node("sounds").set_stream(preload("res://asset/sounds/explo1.wav"))
		get_node("sounds").play()
		body.queue_free()
		lifes -= 1
		_updatehud()
		get_node("tube/obstaclespawner").childs.erase(body)
		get_node("touched/AnimationPlayer").play("Anim")



func _on_restart_pressed():
	get_tree().reload_current_scene()


func _on_menu_pressed():
	get_tree().change_scene("res://scenes/tube/tubemenu.tscn")
