extends Spatial

var started = 0
var score = 0
var closeobject
var mode = ""
var strorystep =""
var npc
var car
var cash = 0
var inventory = ["nothing","bat","gun","mgun"]
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
var talker
var talkervoice
var mission = ""
var missiondata = ["name","desc",0.0,"","goto","ghouse1","normal",""] 
var currentmission
var missions = { # name, desc, timer,restrictions,kind of task, objectiv,kind of car or weapon given,ifthere is a ending cutscene
	"1g" : {
		"name" : "A new start",
		"desc" : "Go to your new house, don't break the car!",
		"startplace" : "gbarshop1",
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
		"startplace" : "gbarshop1",
		"timer" : 30.0,
		"restrictions" : "onlycar",
		"task" : "goto",
		"objectiv" : "gbosshouse1",
		"carorweapon" : "cousincarhq",
		"startcut" : "Green2",
		"endingcut"  : "2g-2",
	} ,
	"2g-2" : {
		"name" : "Job interview",
		"desc" : "Kick the dealers out of the park.",
		"startplace" : "gbosshouse1",
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
	"cousincarhq": ["normal","res://scenes/gta/npc/car2.tres",Vector3(308,0,888)],
}
var weaponstrength = {
	"nothing" : 20.0,
	"bat" : 30.0,
	"gun" : 50.0,
	"mgun" : 40.0,
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
	if(mode == "Gstory"):
		inventory = Global.gtc.Gstoryinventory
		currentweapon = Global.gtc.Gstorycurrentweapon
		crime  = Global.gtc.Gstorycurrentcrime
		get_node("minimap/Viewport/map/arcadezones").visible = false
		strorystep = Global.gtc.get("Gstorystep")
		if(strorystep == "1g"): # intro cutscene
			get_node("Kinemacron").global_transform.origin = Vector3(886.46,0.035,481.674)
			_startmission("1g")
		else:#create the startmission areas
			var startingarea = preload("res://scenes/gta/startmission.tscn")
			startingarea = startingarea.instance()
			get_node(str("town/places/"+missions.get(Global.gtc.get("Gstorystep")).startplace)).add_child(startingarea)
			startingarea.name = strorystep
			var startpoint = preload("res://scenes/gta/objectifpoint.tscn")
			startpoint = startpoint.instance()
			get_node("minimap/Viewport/map/obj").add_child(startpoint)
			startpoint.position = _3Dto2D(get_node(str("town/places/"+missions.get(Global.gtc.get("Gstorystep")).startplace)).global_transform.origin)

	if(mode == "Arcade"):
		inventory = Global.gtc.Arcadeinventory
		currentweapon = Global.gtc.Arcadecurrentweapon
		crime  = Global.gtc.Arcadecurrentcrime
		get_node("Kinemacron")._changegun()
#		get_node("Kinemacron")._radio()
		get_node("Kinemacron")._updateminimap()
	else:
		get_node("hud/enemy").visible = false

	get_node("town/Gridtrot").visible = true
	get_node("town/Gridtrot").visible = false
	get_node("town/Gridroad").visible = true
	get_node("town/Gridroad").visible = false
	minimap = 0
#	_on_minimapbutton_pressed()
	Global._updateadjworldenv()
	if(Global.gtc.spawnpoint != ""):
		get_node("Kinemacron").global_transform.origin = get_node(str("town/places/"+Global.gtc.spawnpoint)).global_transform.origin
		Global.gtc.spawnpoint = ""
	if(Global.gtc.spawnpointtown != ""):
		get_node("Kinemacron").global_transform.origin = get_node(str("town/places/"+Global.gtc.spawnpointtown)).global_transform.origin
		Global.gtc.spawnpointtown = ""






func _3Dto2D(treeD):
	return Vector2((treeD.x / 5.7165 ) / 0.4,(treeD.z /8.1917) / 0.279)

	
func _updatearcadezones(which):
	get_node("sound").set_stream( preload("res://asset/sounds/victory1.wav"))
	get_node("sound").play()
	get_node("Kinemacron")._updateminimap()

func _startmission(which):
	minimap = 0
	currentmission = missions.get(which)
	if(currentmission.startcut != ""):
		_startcutscene(currentmission.startcut)

	if(currentmission.task == "goto"):#create objectif and minimap
		var objectif = preload("res://scenes/gta/objectif.tscn")
		objectif = objectif.instance()
		get_node(str("town/places/"+currentmission.objectiv)).add_child(objectif)
		var objectifpoint = preload("res://scenes/gta/objectifpoint.tscn")
		objectifpoint = objectifpoint.instance()
		get_node("minimap/Viewport/map/obj").add_child(objectifpoint)
		objectifpoint.position = _3Dto2D(get_node(str("town/places/"+currentmission.objectiv)).global_transform.origin)


	if(currentmission.carorweapon != "no"):
		if("car" in currentmission.carorweapon ):#spawn the car you will use
			var newcar = preload("res://scenes/kinematic/gtacar.tscn")
			newcar = newcar.instance()
			newcar.typeofcar = currentmission.carorweapon
			newcar._specialcar = currentmission.carorweapon
			newcar._owner = "player"
			add_child(newcar)
			
			newcar.global_transform.origin = missionscars.get(currentmission.carorweapon)[2]
		else:# only weapons 
			inventory.append(currentmission.carorweapon)
	
	if( "onlycar" in currentmission.restrictions):
		get_node("Kinemacron").global_transform.origin = missionscars.get(currentmission.carorweapon)[2]
		_playeraction("A")

func _updatemission(what,wich):
			get_node("hud/timeleft").visible = false
			if(what == "progress"):
				if( "end" in currentmission.endingcut):#means it's an ending cutscene
					_startcutscene(currentmission.endingcut)
				else:# continu the mission , endindcut is name of next step
					_startmission(currentmission.endingcut)

func _playeraction(which):
	if(which == "A"):
		get_node("Kinemacron")._on_A_pressed()

func _endgame():
	get_node("Kinemacron").camheight = 10
	if(mode == "Arcade"):
		Global.gtc.Arcadecash = 0
		Global.gtc.Arcadeinventory =  ["nothing",]
		Global.gtc.Arcadecurrentweapon = "nothing"
		Global.gtc.Arcadecurrentlife = 1000
		Global.gtc.Arcadecurrentcrime = 0.0
		Global.gtc.Arcadecurrentarmor = 0
		Global.gtc.Arcadeammogun = 0
		Global.gtc.Arcadeammomgun = 0
		Global.gtc.Arcadelastspawn = ""
		Global.gtc.radioarcade = ""
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
		get_node("Kinemacron").mode = "dead"
		get_node("Kinemacron")._showhidehud("hide")
		get_node("hud/touched/AnimationPlayer").play("endgame")
		get_node("Kinemacron/phone").visible = false
		get_node("Kinemacron").set_process(false)
		get_node("Kinemacron").Animleg.play("die")
		



func _closeobject(what):
	if(what == "null"):
		get_node("Kinemacron/A/icon").texture = null
	if(what == "car" or what == "carchest"):
		get_node("Kinemacron/A/icon").texture = preload("res://asset/textures/gta/car1.png")
		
		
	if(what == "door"):
		get_node("Kinemacron/A/icon").texture = preload("res://asset/textures/32text/32door2.png")

func _spawnnpc(where):
	if(get_node("spawndelay").is_stopped()):
		npc = preload("res://scenes/kinematic/npcgta.tscn").instance()
		self.add_child(npc)
		npc.global_transform.origin = where
		justspawn = 1
		npcnear += 1
		get_node("spawndelay").start()
	else:
		return

func _spawncar(where):
	if(get_node("spawndelaycar").is_stopped()):
		car = preload("res://scenes/kinematic/gtacar.tscn").instance()
		self.add_child(car)
		car.global_transform.origin = where
		justspawncar = 1
		carnear += 1
		get_node("spawndelaycar").start()
	else:
		return

func _on_spawndelay_timeout():
	justspawn = 0

func _on_spawndelaycar_timeout():
	justspawncar = 0

func _spawnblood(whereblood,size):
	var _blood2 = _blood.instance()
	self.add_child(_blood2)
	_blood2.global_transform.origin = whereblood
	if(size == "small"):
		_blood2.scale = Vector3(0.5,0.5,0.5)




func _closetextbox():
	get_node("text/bg").visible = false
	get_node("text/Label").visible_characters = 0

func _opendtextbox(_text):
	get_node("text/bg").visible = true
	get_node("text/Label").visible_characters = 0
	get_node("text/Label").set_text(get_node("text").cutscenetext.get(_text))
	get_node("textspeed").start()
	if(get_node("text").cutscenanim.get(_text) != ""):
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
	started = 0

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
	minimap = 0
	get_node("minimap").visible = true
	minimap = 0
#	_on_minimapbutton_pressed()
	get_node("Kinemacron").visible = true
	if("end" in get_node("cutscene").get_child(0).name): #new story step !
		currentmission = ""
		if(mode == "Gstory"):
			var dictkeys = missions.keys()
			var currentkey = dictkeys.find(Global.gtc.get("Gstorystep"))
			Global.gtc.Gstorystep = dictkeys[currentkey+1]


	else: #  in mission
		if( "onlycar" in currentmission.restrictions):
			_playeraction("A")
			get_node("music").play()
		if(currentmission.timer != 0.0):
			get_node("hud/timeleft").visible = true
			get_node("missiontimer").wait_time = currentmission.timer
			get_node("missiontimer").start()
			
	get_node("cutscene").get_child(0).queue_free()

func _on_skip_pressed():
	_endcutscene()

func _on_missiontimer_timeout():
	pass # Replace with function body.


