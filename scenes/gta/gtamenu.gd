extends Control

var _level = 4
var _levelselected = 1
var _mode = "Arcade"
var trophies = [1,0,1,0,1,0,1,0,1,0,1,0]
var trophyselected = null
var trophiestext = {
	0 : "arcade1",
	1 : "arcade2",
	2 : "arcade3",
	3 : "arcade4",
	4 : "Story 1 finished",
	5 : "Story 2 finished",
	6 : "Story 3 finished",
	7 : "Story 4 finished",
	8 : "Story 1 bonus",
	9 : "Story 2 bonus",
	10 : "Story 3 bonus",
	11 : "Story 4 bonus",
}

var leveldesc = {
	"Arcade" : "William Foster is back! And he want to kill all the gangsters!",
	"Gstory" : "Green Story.",
	"Zombie" : "When there's no more room in hell, the dead will walk the earth.",
}
onready var zombies = preload("res://scenes/gta/cutscene/zombie.tscn")
func _ready():
	_mode = Global.gtc.modeselected
#	_level = Global.kiri.level
#	_levelselected = _level
	_updatescore()
	trophies = Global.gtc.trophies

	for i in get_node("trophises").get_child_count():
		if(trophies[i] == 1):
			get_node("trophises").get_child(i).get_node("Sprite").set_self_modulate("ffc500")
	_trophy("0")

#func _on_kiributton_pressed(which):
#	if(str2var(which) <= _level):
#		_levelselected = str2var(which)
#		_updatescore()
		


func _updatescore():
	get_node("ViewportContainer/Viewport/Spatial/Camera/AnimationPlayer").stop()
	if(get_tree().current_scene.find_node("zombie",true,false) != null):
		get_tree().current_scene.find_node("zombie",true,false).queue_free()
	get_node("menu/desclevel").set_text(leveldesc.get(_mode))

	
	if(_mode =="Arcade"):
		get_node("menu/titledead").visible = false
		get_node("menu/mode2").visible = true
		get_node("ViewportContainer/Viewport/Spatial/town/WorldEnvironment").set_environment(load("res://scenes/gta/worldenv/arcadeenv.tres"))
		get_node("menu/start").set_text("Start Falling Down Mode")
		get_node("menu/mode2").set_text("Falling\nDown\n2")
		get_node("bgs/Sprite2/greenlogo").visible = false
		get_node("bgs/Sprite2/arcadelogo").visible = true
		
		get_node("bgs/Sprite2/zombielogo").visible = false
		get_node("menu/arcademisc").visible = true
		get_node("ViewportContainer/Viewport/Spatial/Camera/AnimationPlayer").play("arcade")
		get_node("AudioStreamPlayer").set_stream(load("res://asset/sounds/arcadetheme.ogg"))
		get_node("AudioStreamPlayer").play()
		var arcadescore = 0
		for i in Global.gtc.Arcadeenemies :

			arcadescore += Global.gtc.Arcadeenemies[i]
		arcadescore+= 4
		arcadescore = 100 - arcadescore
		if(arcadescore == 0):
			get_node("menu/file").set_text("File : Empty")
		else:
			get_node("menu/file").set_text("File : "+ str(arcadescore) + "/ 100")
			
	if(_mode =="Gstory"):
		get_node("menu/titledead").visible = false
		get_node("menu/mode2").visible = true
		get_node("ViewportContainer/Viewport/Spatial/town/WorldEnvironment").set_environment(load("res://scenes/gta/worldenv/arcadeenv.tres"))
		get_node("menu/start").set_text("Probably canceled")
		get_node("menu/mode2").set_text(_mode)
		get_node("bgs/Sprite2/greenlogo").visible = true
		get_node("bgs/Sprite2/arcadelogo").visible = false
		get_node("bgs/Sprite2/zombielogo").visible = false
		get_node("menu/arcademisc").visible = false
		get_node("ViewportContainer/Viewport/Spatial/Camera/AnimationPlayer").play("base")
		get_node("AudioStreamPlayer").set_stream(load("res://asset/sounds/withbass.ogg"))
		get_node("AudioStreamPlayer").play()
#	get_node("menu/score").set_text("Best time : 00:" +  str(Global.kiri.time[_levelselected -1]))
#	get_node("menu/bird").global_position = get_node("menu/level/" + str(_levelselected)).global_position + Vector2(16,0)

	if(_mode =="Zombie"):
		get_node("menu/titledead").visible = true
		get_node("menu/mode2").visible = false
		zombies = preload("res://scenes/gta/cutscene/zombie.tscn")
		zombies = zombies.instance()
		get_node("ViewportContainer/Viewport/Spatial/town").add_child(zombies)
		get_node("ViewportContainer/Viewport/Spatial/town/WorldEnvironment").set_environment(load("res://scenes/gta/worldenv/zombieenv.tres"))
		get_node("menu/start").set_text("Start Zombie")
		get_node("menu/mode2").set_text(_mode)
		get_node("bgs/Sprite2/greenlogo").visible = false
		get_node("bgs/Sprite2/arcadelogo").visible = false
		get_node("bgs/Sprite2/zombielogo").visible = true
		get_node("menu/arcademisc").visible = false
		get_node("menu/mode2").set_text("TOWN\nof the\nDEAD")
		get_node("ViewportContainer/Viewport/Spatial/Camera/AnimationPlayer").play("zombie")
		get_node("AudioStreamPlayer").set_stream(load("res://asset/sounds/zombie2.ogg"))
		get_node("AudioStreamPlayer").play()

func _on_quit_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")

func _trophy(which):
	get_node("menu/desctrophies").set_text(trophiestext.get(which.to_int()))
	get_node("bgs/cursortroph").position = get_node(str("trophises/" + which)     ).rect_position




func _on_start_pressed():
	Global.gtc.modeselected = _mode
	if(_mode == "Arcade"):
		get_tree().change_scene("res://scenes/gta/town.tscn")


	if(_mode == "Zombie"):
		if(Global.gtc.Zombiecurrentscene  == ""):
			
			get_tree().change_scene("res://scenes/gta/building2fps.tscn")
		else:

			get_tree().change_scene(Global.gtc.Zombiecurrentscene)


func _on_left_pressed():

	if(_mode == "Arcade"):
		_mode = "Zombie"
		_updatescore()
		return
	if(_mode == "Zombie"):
		_mode = "Gstory"
		_updatescore()
		return
	if(_mode == "Gstory"):
		_mode = "Arcade"
		_updatescore()
		return

func _on_right_pressed():
	if(_mode == "Arcade"):
		_mode = "Gstory"
		_updatescore()
		return
	if(_mode == "Gstory"):
		_mode = "Zombie"
		_updatescore()
		return
	if(_mode == "Zombie"):
		_mode = "Arcade"
		_updatescore()
		return


func _on_reset_pressed():
	print(_mode)
	if(_mode == "Arcade"):
		Global.gtc.Arcadecash = 0
		Global.gtc.Arcadeinventory =  ["nothing",]
		Global.gtc.Arcadecurrentweapon = "nothing"
		Global.gtc.Arcadecurrentlife = 1000
		Global.gtc.Arcadecurrentcrime = 0.0
		Global.gtc.Arcadecurrentarmor = 0
		Global.gtc.Arcadeammogun = 0
		Global.gtc.Arcadeammomgun = 0
		Global.gtc.Arcadelastspawn = ""
		Global.gtc.radioarcade = false
		Global.gtc.Arcadeenemies = {
		"G1" : 6,
		"G2" : 6,
		"G3" : 6,
		"G4" : 6,
		"Y1" : 6,
		"Y2" : 6,
		"Y3" : 6,
		"Y4" : 6,
		"B1" : 6,
		"B2" : 6,
		"B3" : 6,
		"B4" : 6,
		"R1" : 6,
		"R2" : 6,
		"R3" : 6,
		"R4" : 6,}
	Global._savegame()
	Global._loadgame()
	_updatescore()
