extends Spatial

var started = 0
var score = 0

var closeobject
var mode = "Gstory"
var strorystep =""
var npc
var car

var cash = 0
var inventory = ["nothing","bat","gun"]
var currentweapon = "nothing"
var crime = 0.0
var currentarea = ""

var npcnear = 0
var maxnpc = 6
var carnear = 0
var maxcar = 6
var justspawn = 0
var justspawncar = 0
var minimap = 0
var color = ""
var talker
var talkervoice
var mission = ""
var missiondata = ["name","desc",0.0,"","goto","ghouse1","normal",""] 
var currentmission
var missions = { # name, desc, timer,restrictions,kind of task, objectiv,kind of car or weapon given,ifthere is a ending cutscene
	"1g" : {
		"name" : "A new start",
		"desc" : "Go to your new house, don't break the car!",
		"timer" : 0.0,
		"restrictions" : "onlycar",
		"task" : "goto",
		"objectiv" : "ghouse1",
		"carorweapon" : "cousincarairport",
		"startcut" : "Green1",
		"endingcut"  : "Green1end",
	} ,
	"2g-1" : {
		"name" : "Job interview",
		"desc" : "Go to the house of your new boss.",
		"timer" : 30.0,
		"restrictions" : "onlycar",
		"task" : "goto",
		"objectiv" : "gbosshouse1",
		"carorweapon" : "cousincarhq",
		"startcut" : "",
		"endingcut"  : "2g-2",
	} ,
	"2g-2" : {
		"name" : "Job interview",
		"desc" : "Kick the dealers out of the park.",
		"timer" : 00.0,
		"restrictions" : "no",
		"task" : "kill",
		"objectiv" : "ennemy2g",
		"carorweapon" : "bat",
		"startcut" : "",
		"endingcut"  : "Green2-2end?",
	} ,
}
var missionscars = {
	"example": ["model","material","position"],
	"cousincarairport": ["normal","res://scenes/gta/npc/car2.tres",Vector3(887.1,0,481.8)],
	"cousincarairhq": ["normal","res://scenes/gta/npc/car2.tres",Vector3(887.1,0,481.8)],
}
var weaponstrength = {
	"nothing" : 20.0,
	"bat" : 30.0,
	"gun" : 50.0,
}
var missionsreward = {# cash , objects
	"1g" : [50, "New house."],
	"2g" : [100, "nothing"],
	}
var cutscene
onready var missiontargetplace #= get_node("places/ghouse1").global_transform.origin
onready var _blood = preload("res://scenes/kinematic/blood1.tscn")
onready var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	mode = Global.gtc.modeselected

	Global._updateadjworldenv()
	if(mode == "Gstory"):
		inventory = Global.gtc.Gstoryinventory
		currentweapon = Global.gtc.Gstorycurrentweapon
		crime  = Global.gtc.Gstorycurrentcrime
		if(Global.gtc.get("Gstorystep") == "1g"): # if it's the bigining
			_startcutscene("Green1end")
	if("bar" in name):
		if("gbar" in Global.gtc.spawnpointtown):
			color = "6ac85d"
		if("ybar" in Global.gtc.spawnpointtown):
			color = "c8bc5d"
		if("bbar" in Global.gtc.spawnpointtown):
			color = "5d6bc8"
		if("rbar" in Global.gtc.spawnpointtown):
			color = "c85d5d"

		var mat1 
		
		mat1 = get_node("house/MeshInstance").mesh.surface_get_material(0)
		mat1 = mat1.duplicate()
		mat1.set_albedo(color)

		get_node("house/MeshInstance").set_surface_material(0,mat1)
		
		var mat2 = get_node("house/MeshInstance").mesh.surface_get_material(2)
		mat2 = mat2.duplicate()
		mat2.set_albedo(color)

		get_node("house/MeshInstance").set_surface_material(2,mat2)
	if(mode == "Arcade"):
		inventory = Global.gtc.Arcadeinventory
		currentweapon = Global.gtc.Arcadecurrentweapon
		crime  = Global.gtc.Arcadecurrentcrime
		get_node("Kinemacron")._changegun()
#		_radio()
		
	if(Global.gtc.spawnpoint != ""):
		get_node("Kinemacron").global_transform.origin = get_tree().current_scene.find_node(Global.gtc.spawnpoint).global_transform.origin
		Global.gtc.spawnpoint = ""


func _radio():
	if(Global.gtc.radioarcade == false):
		get_node("music").stop()
	else:
		get_node("music").stop()
		var songs = rng.randi_range(0,Global.gtcradio.size() -1 )
		var songplayed = Global.gtcradio.keys()[songs]
		songplayed = load(Global.gtcradio.get(songplayed))
		get_node("music").set_stream(songplayed) 
		get_node("music").play()


func _endcutscene():
	get_node("skip").visible = false
	get_node("Kinemacron")._showhidehud("show")
	get_node("Camera/Camera").current = true
	get_node("music").stop()
	get_node("text/bg").visible = false
	get_node("text/Label").visible_characters = 0
	get_node("textspeed").stop()
#	get_node("cutscene").get_child(0).find_node("animcutscene").stop()
	started = 1
	get_node("Kinemacron").visible = true
	if("end" in get_node("cutscene").get_child(0).name):
		currentmission = ""
		if(mode == "Gstory"):
			var dictkeys = missions.keys()
			var currentkey = dictkeys.find(Global.gtc.get("Gstorystep"))
			Global.gtc.Gstorystep = dictkeys[currentkey+1]
	else:
		if( "onlycar" in currentmission.restrictions):
			_playeraction("A")
			get_node("music").play()
		if(currentmission.timer != 0.0):
			get_node("hud/timeleft").visible = true
			get_node("missiontimer").wait_time = currentmission.timer
			get_node("missiontimer").start()
	get_node("cutscene").get_child(0).queue_free()
	
func _startcutscene(which):
	get_node("skip").visible = true
	get_node("Kinemacron").visible = false
	get_node("loading/AnimationPlayer").play("load")
	get_node("Kinemacron")._showhidehud("hide")
	if(get_node("cutscene").get_child_count() > 0  ):
		get_node("cutscene").get_child(0).queue_free()
	var cutscenepath = "res://scenes/gta/cutscene/"+which+".tscn"
	cutscene = load(cutscenepath)
	var cutscene2 = cutscene.instance()
	get_node("cutscene").add_child(cutscene2)

	get_node("Camera/Camera").current = true
	get_node("music").stop()
#	get_tree().current_scene.find_node("animcutscene").stop()
	started = 0
#	get_tree().current_scene.find_node("animcutscene").play(which)


func _playeraction(which):
	if(which == "A"):
		get_node("Kinemacron")._on_A_pressed()
	


func _closeobject(what):
	if(what == "null"):
		get_node("Kinemacron/A/icon").texture = null
	if(what == "car"):
		get_node("Kinemacron/A/icon").texture = preload("res://asset/textures/gta/car1.png")
	if(what == "door"):
		get_node("Kinemacron/A/icon").texture = preload("res://asset/textures/32text/32door2.png")

	if(what == "intdoor"):
		get_node("Kinemacron/A/icon").texture = preload("res://asset/textures/32text/32door2.png")

	if(  "shop" in what):
		get_node("Kinemacron/A/icon").texture = preload("res://asset/textures/32text/cash.png")


func _spawnblood(whereblood,size):
	var _blood2 = _blood.instance()
	self.add_child(_blood2)
	_blood2.global_transform.origin = whereblood
	if(size == "small"):
		_blood2.scale = Vector3(0.5,0.5,0.5)


func _on_quit_pressed():
		get_tree().change_scene("res://scenes/MainMenu.tscn")

func _opendshoptextbox():
	get_node("text/bg").visible = true
	get_node("text/shopdesc").visible = true
	get_node("text/shopprice").visible = true
	get_node("text/shopdesc").set_text(closeobject.descs.get(closeobject._kind)  )
	get_node("text/shopprice").set_text(str(closeobject.prices.get(closeobject._kind)) +" $")
	

	
	
	
func _closedshoptextbox():
	get_node("text/bg").visible = false
	get_node("text/shopdesc").visible = false
	get_node("text/shopprice").visible = false
	get_node("text/shopdesc").set_text("")
	get_node("text/shopprice").set_text("")
	
	
	
func _closetextbox():
	get_node("text/bg").visible = false
	get_node("text/Label").visible_characters = 0
	
func _opendtextbox(_text):
	get_node("text/bg").visible = true
	get_node("text/Label").visible_characters = 0
	get_node("text/Label").set_text(get_node("text").cutscenetext.get(_text))
	get_node("textspeed").start()
	if(get_node("text").cutscenanim.get(_text) != ""):#
		talker = get_node("cutscene").get_child(0).find_node(get_node("text").cutscenanim.get(_text))
		talker._playanim("talk")
		
	talkervoice = get_node("text").cutscenvoice.get(_text)
	get_node("text/voice").set_stream(get_node("text").voices.get(talkervoice))

func _on_textspeed_timeout():
	get_node("text/Label").visible_characters +=1
	if(get_node("text/voice").is_playing() == false):
		get_node("text/voice").play()
		talker._playanim("mouth")
	if(get_node("text/Label").visible_characters < get_node("text/Label").get_total_character_count()):
			get_node("textspeed").start()

func _on_skip_pressed():
	_endcutscene()

func _opendoor(which):
	get_tree().current_scene.find_node(which)._open()
