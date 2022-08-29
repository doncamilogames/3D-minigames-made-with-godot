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
var _father
var _mother
var _brother
var _sister

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
onready var _blood = preload("res://scenes/kinematic/blood1.tscn")
onready var rng = RandomNumberGenerator.new()
onready var _relativ = preload("res://scenes/gta/relativfps.tscn")

func _ready():
	started = 1
	rng.randomize()
	mode = Global.gtc.modeselected
	inventory = Global.gtc.Zombieinventory
	currentweapon = Global.gtc.Zombiecurrentweapon
	get_node("KineFPS")._changegun()
	Global._updateadjworldenv()
	

	var needcutscene = 0

	if("hospital" in Global.gtc.Zombielastspawn):
		if(Global.gtc.Zombielastspawn != "hospital1"):
			get_node("MeshInstance/7/props/fridgemother").queue_free()

	if("police" in Global.gtc.Zombielastspawn):
		if(Global.gtc.Zombielastspawn != "police1"):
			get_node("MeshInstance/5/props/mayordesk").queue_free()

	if(Global.gtc.Zombielastspawn == "sisterwork"):
		if(Global.gtc.Zombielastspawn == "sisterwork"): #cutscene first time, help
			color = "ffffff"
			if(Global.gtc.Zombieswitch.find("sistermet") == -1):
				_startcutscene("sistermet")
				needcutscene = 1
				Global.gtc.Zombieswitch.append("sistermet")

			else:
				get_node("cutscene/sister").queue_free()
				

	if("house" in Global.gtc.Zombielastspawn):
		if(Global.gtc.Zombielastspawn == "myhouse"): #cutscene intro
			color = "498142"
			if(Global.gtc.Zombieswitch.find("intro1") == -1):
				_startcutscene("intro1")
				needcutscene = 1
				Global.gtc.Zombieswitch.append("intro1")
			else:
				get_node("cutscene/intro1").queue_free()
				get_node("KineFPS/Camerafps").current = true
				


		if(Global.gtc.Zombielastspawn == "parenthouse"):
			color = "7180d0"
			if(Global.gtc.Zombieswitch.find("parentmet") == -1):
				Global.gtc.Zombieswitch.append("parentmet")
				needcutscene = 1
				if(get_node("KineFPS").ingameh < 23 and get_node("KineFPS").ingameh > 7):#meet parents, go to hospital
					_startcutscene("meetparent22")
					Global.gtc.Zombierelativ.get("father")[1] = "home"
					Global.gtc.Zombierelativ.get("father")[2] = "parent"
					Global.gtc.Zombierelativ.get("father")[3] = "father2"
					Global.gtc.Zombierelativ.get("mother")[3] = "mother2"
					Global.gtc.Zombieswitch.append("gotohospital")
				elif(get_node("KineFPS").ingameh >= 23 or get_node("KineFPS").ingameh < 01 ):#meet parents, go to hospital
					_startcutscene("meetparent23")
					Global.gtc.Zombierelativ.get("father")[3] = "father2"
					Global.gtc.Zombierelativ.get("mother")[3] = "mother2"
					Global.gtc.Zombieswitch.append("gotohospital")
				elif(get_node("KineFPS").ingameh >= 1 or get_node("KineFPS").ingameh < 06 ):#meet father, mother dead, wait 3-4AM to go
					_startcutscene("meetparent01")
					Global.gtc.Zombierelativ.get("father")[3] = "father9"
					
	#			elif(get_node("KineFPS").ingameh == 3):#meet father, mother dead, go to port
	#				_startcutscene("meetparent03")
	#				Global.gtc.Zombierelativ.get("father")[1] = "road"
	#				Global.gtc.Zombierelativ.get("father")[2] = "eastport"
	#				Global.gtc.Zombierelativ.get("father")[3] = "father4"
#
	###			elif(get_node("KineFPS").ingameh >= 4 or get_node("KineFPS").ingameh < 07 ):#house empty, mother dead
	#				_startcutscene("meetparent01")

			else:
				if(Global.gtc.Zombieswitch.find("parenthelp") == -1):
					if(get_node("KineFPS").ingameh >= 01 and  get_node("KineFPS").ingameh < 07  ):
						if(Global.gtc.Zombieswitch.find("motherdeadhome") == -1):
							needcutscene = 1#cutscene tell dead mother
							_startcutscene("meetparent01")
							Global.gtc.Zombierelativ.get("father")[3] = "father9"
							Global.gtc.Zombieswitch.append("motherdeadhome")
							
						else:
							pass #add thing to hide mother head
					else:
						if(Global.gtc.Zombieswitch.find("medecinemother") != -1):
							needcutscene = 1#cutscene help parent
							Global.gtc.Zombierelativ.get("father")[3] = "father9"
							Global.gtc.Zombierelativ.get("mother")[3] = "father9"
							Global.gtc.Zombierelativ.get("mother")[0] = "fine"
							Global.gtc.Zombieswitch.append("parenthelp")
							_startcutscene("parenthelp")
							
	#				if(get_node("KineFPS").ingameh >= 03 and  get_node("KineFPS").ingameh < 07  ):
	#						needcutscene = 1#cutscene escort parent
						
				else:
					pass# remove mother of bed
		#			if(get_node("KineFPS").ingameh >= 03 and  get_node("KineFPS").ingameh < 07  ):
			#			if(Global.gtc.Zombieswitch.find("parentescort") == -1):
			#				Global.gtc.Zombieswitch.append("parentescort")


		if(Global.gtc.Zombielastspawn == "sisterhouse"):#cutscene, escorting, or between 3&4,
			color = "d3c20c"
			
		if(Global.gtc.Zombielastspawn == "brotherhouse"): #cutscene first time, help
			color = "ffffff"
			if(Global.gtc.Zombieswitch.find("brothermet") == -1):
				_startcutscene("brothermet")
				needcutscene = 1
				Global.gtc.Zombieswitch.append("brothermet")

			else:
				get_node("cutscene/brother").queue_free()
				

				
				
				
		var mat1 
		mat1 = get_node("MeshInstance").mesh.surface_get_material(1)
		mat1 = mat1.duplicate()
		mat1.set_albedo(color)
		get_node("MeshInstance").set_surface_material(1,mat1)
		
		var mat2 = get_node("MeshInstance").mesh.surface_get_material(4)
		mat2 = mat2.duplicate()
		mat2.set_albedo(color)
		get_node("MeshInstance").set_surface_material(4,mat2)
		
		var mat3 = get_node("MeshInstance").mesh.surface_get_material(5)
		mat3 = mat3.duplicate()
		mat3.set_albedo(color)
		get_node("MeshInstance").set_surface_material(5,mat3)

		
		

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


	if(Global.gtc.spawnpoint != ""):
			get_node("KineFPS").global_transform.origin = get_tree().current_scene.find_node(Global.gtc.spawnpoint).global_transform.origin
			Global.gtc.spawnpoint = ""


	if(needcutscene == 0): #just to be sure to have the right camera
		get_node("KineFPS/Camerafps").current = true


	if(Global.gtc.Zombiegoods.find("father") != -1):
		_father = _relativ.instance()
		_father.npctype = "father"
		_father.life = Global.gtc.Zombierelativ.get("father")[4]
		add_child(_father)
		_father.global_transform = get_node("KineFPS").global_transform
		_father.global_transform.origin.z -= 0.4
		get_node("KineFPS/hud/fatherlife").visible = true
		
	if(Global.gtc.Zombiegoods.find("mother") != -1):
		_mother = _relativ.instance()
		_mother.npctype = "mother"
		_mother.life = Global.gtc.Zombierelativ.get("mother")[4]
		add_child(_mother)
		_mother.global_transform = get_node("KineFPS").global_transform
		_mother.global_transform.origin.z += 0.4
		get_node("KineFPS/hud/motherlife").visible = true
	if(Global.gtc.Zombiegoods.find("brother") != -1):
		_brother = _relativ.instance()
		_brother.npctype = "brother"
		_brother.life = Global.gtc.Zombierelativ.get("brother")[4]
		add_child(_brother)
		_brother.global_transform = get_node("KineFPS").global_transform
		_brother.global_transform.origin.x -= 0.4
		get_node("KineFPS/hud/brotherlife").visible = true
	if(Global.gtc.Zombiegoods.find("sister") != -1):
		_sister = _relativ.instance()
		_sister.npctype = "sister"
		_sister.life = Global.gtc.Zombierelativ.get("sister")[4]
		add_child(_sister)
		_sister.global_transform = get_node("KineFPS").global_transform
		_sister.global_transform.origin.x += 0.4
		get_node("KineFPS/hud/sisterlife").visible = true



func _endgame():
		get_node("Camera/Camera").global_translation.y = 10
		get_node("Camera/Camera").current = true
		get_node("KineFPS").mode = "dead"
		get_node("KineFPS")._showhidehud("hide")
		get_node("hud/touched/AnimationPlayer").play("endgame")
		get_node("KineFPS/phone").visible = false
		get_node("KineFPS").Animleg.play("die")
		


func _radio():
	if(Global.gtc.radioZombie == ""):
		#get_node("music").stop()
		pass
	else:
		get_node("music").stop()
		var songs = rng.randi_range(0,Global.gtcradio.size() -1 )
		var songplayed = Global.gtcradio.keys()[songs]
		songplayed = load(Global.gtcradio.get(songplayed))
		get_node("music").set_stream(songplayed) 
		get_node("music").play()


func _endcutscene():
	get_node("KineFPS")._showhidehud("show")
	get_node("Camera/Camera").current = false
	#get_node("music").stop()
	get_node("text/Label").visible_characters = 0
	get_node("textspeed").stop()
#	get_node("cutscene").get_child(0).find_node("animcutscene").stop()
	started = 1
	get_node("KineFPS").set_process(true)
	get_node("KineFPS/Camerafps").current = true



	
func _startcutscene(which):
	started = 0
	get_node("KineFPS").set_process(false)
	get_node("KineFPS")._showhidehud("hide")

	if(which == "intro1"):
		get_node("cutscene/intro1/AnimationPlayer").play("intro")
	if(which == "meetparent22"):
		get_node("cutscene/meetparent22/AnimationPlayer").play("meetparent22")
	if(which == "meetparent23"):
		get_node("cutscene/meetparent23/AnimationPlayer").play("meetparent23")
	if(which == "meetparent01"):
		get_node("cutscene/meetparent01/AnimationPlayer").play("meetparent01")
	if(which == "parenthelp"):
		get_node("cutscene/parenthelp/AnimationPlayer").play("parenthelp")
	if(which == "brothermet"):
		get_node("cutscene/meetbrother/AnimationPlayer").play("meetbrother")
	if(which == "sistermet"):
		get_node("cutscene/meetsister/AnimationPlayer").play("meetsister")
		
		
	get_node("Camera/Camera").current = true
	get_node("music").stop()




func _playeraction(which):
	if(which == "A"):
		get_node("KineFPS")._on_A_pressed()
	
func cutsceneaction(who, what):
	get_tree().current_scene.find_node(who,true,false)._playanim(what)


func _closeobject(what):
	if(what == "null"):
		get_node("KineFPS/A/icon").texture = null
	if(what == "car"):
		get_node("KineFPS/A/icon").texture = preload("res://asset/textures/gta/car1.png")
	if(what == "door"):
		get_node("KineFPS/A/icon").texture = preload("res://asset/textures/32text/32door2.png")

	if(what == "intdoor"):
		get_node("KineFPS/A/icon").texture = preload("res://asset/textures/32text/32door2.png")

	if(  "shop" in what):
		get_node("KineFPS/A/icon").texture = preload("res://asset/textures/32text/cash.png")
	if(  "fridge" in what):
		get_node("KineFPS/A/icon").texture = preload("res://asset/textures/32text/fridge1.png")


func _spawnblood(whereblood,size):
	var _blood2 = _blood.instance()
	self.add_child(_blood2)
	_blood2.global_transform.origin = whereblood
	if(size == "small"):
		_blood2.scale = Vector3(0.5,0.5,0.5)




func _opendshoptextbox():
	get_node("text/bg").visible = true
	get_node("text/shopdesc").visible = true
	get_node("text/shopprice").visible = true
	get_node("text/shopdesc").set_text(closeobject.descs.get(closeobject._kind)  )
	get_node("text/shopprice").set_text(str(closeobject.prices.get(closeobject._kind)) +" $")
	

func _closedshoptextbox():
	get_node("text/shopdesc").visible = false
	get_node("text/shopprice").visible = false
	get_node("text/shopdesc").set_text("")
	get_node("text/shopprice").set_text("")
	
	
	
func _closetextbox():
	get_node("text/Label").modulate= "00ffffff"
	get_node("textspeed").stop()
	get_node("text/Label").visible_characters = -1
	
func _opendtextbox(_text):
	get_node("text/Label").modulate= "ffffff"
	get_node("text/Label").visible_characters = 0
	get_node("text/Label").set_text(get_node("text").cutscenetext.get(_text))
	get_node("textspeed").start()
	talkervoice = get_node("text").cutscenvoice.get(_text)
	if(get_node("text").cutscenanim.has(_text) ):
		talker = get_tree().current_scene.find_node(get_node("text").cutscenanim.get(_text),true,false)
		talkervoice = get_node("text").cutscenvoice.get(talker.name)

	else:
		talker = null
	get_node("text/voice").set_stream(get_node("text").voices.get(talkervoice))
	
	
func _openphonetextbox(text, who):
	talker = null
	get_node("text/Label").modulate= "ffffff"
	get_node("text/Label").visible_characters = 0
	get_node("text/Label").set_text(text)
	get_node("textspeed").start()
	talkervoice = get_node("text").cutscenvoice.get(who)
	get_node("text/voice").set_stream(get_node("text").voices.get(talkervoice))


func _on_textspeed_timeout():
	get_node("text/Label").visible_characters +=1
	if(get_node("text/voice").is_playing() == false):
		get_node("text/voice").play()
	if(talker != null):
		talker._playanim("mouth")
	if(get_node("text/Label").visible_characters < get_node("text/Label").get_total_character_count()):
			get_node("textspeed").start()

func _opendoor(which):
	get_tree().current_scene.find_node(which)._open()

func _reloadscene():

	if(Global.gtc.Zombielastspawn == "brotherhouse"): #cutscene first time, help
		if(Global.gtc.Zombiegoods.find("brother") == -1): #cutscene first time, help
			Global.gtc.Zombiegoods.append("brother")
			
	if(Global.gtc.Zombielastspawn == "sisterwork"): #cutscene first time, help
		if(Global.gtc.Zombiegoods.find("sister") == -1): #cutscene first time, help
			Global.gtc.Zombiegoods.append("sister")
			
	get_tree().reload_current_scene()
