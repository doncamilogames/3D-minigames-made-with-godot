extends Spatial

var started = 0
var closeobject
var mode = ""
var npc
var car
var cash = 0
var inventory = ["nothing","bat","gun","mgun"]
var currentweapon = "nothing"

var npcnear = 0
var maxnpc = 30
var carnear = 0
var maxcar = 15
var justspawncar = 0
var justspawn = 0

var minimap = 2
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

var cutscene

onready var _blood = preload("res://scenes/kinematic/blood1.tscn")
onready var _relativ = preload("res://scenes/gta/relativfps.tscn")
onready var rng = RandomNumberGenerator.new()



func _ready():
	started = 1
	rng.randomize()
	mode = Global.gtc.modeselected
	inventory = Global.gtc.Zombieinventory
	currentweapon = Global.gtc.Zombiecurrentweapon
	get_node("KineFPS")._changegun()
	get_node("town/Gridroad").visible = true
	get_node("town/Gridroad").visible = false
	Global._updateadjworldenv()
	
	
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





func _radio():
	if(Global.gtc.radioZombie == ""):
	#	get_node("music").stop()
		pass
	else:
		
		get_node("music").stop()
		var songs = rng.randi_range(0,Global.gtcradio.size() -1 )
		var songplayed = Global.gtcradio.keys()[songs]
		songplayed = load(Global.gtcradio.get(songplayed))
		get_node("music").set_stream(songplayed) 
		get_node("music").play()



func _3Dto2D(treeD):
	return Vector2((treeD.x / 5.7165 ) / 0.4,(treeD.z /8.1917) / 0.279)



func _playeraction(which):
	if(which == "A"):
		get_node("KineFPS")._on_A_pressed()

func _endgame():
		get_node("Camera/Camera").global_translation.y = 10
		get_node("Camera/Camera").current = true
		get_node("KineFPS").mode = "dead"
		get_node("KineFPS")._showhidehud("hide")
		get_node("KineFPS/hud/touched/AnimationPlayer").play("endgame")
		get_node("KineFPS/phone").visible = false
		get_node("KineFPS").Animleg.play("die")



func _closeobject(what):
	if(what == "null"):
		get_node("KineFPS/A/icon").texture = null
	if(what == "car" or what == "carchest"):
		get_node("KineFPS/A/icon").texture = preload("res://asset/textures/gta/car1.png")
	if(what == "door"):
		get_node("KineFPS/A/icon").texture = preload("res://asset/textures/32text/32door2.png")
	if(  "fridge" in what):
		get_node("KineFPS/A/icon").texture = preload("res://asset/textures/32text/fridge1.png")
	if(what == "intdoor"):
		get_node("KineFPS/A/icon").texture = preload("res://asset/textures/32text/32door2.png")

func _spawnnpc(where):
	if(get_node("spawndelay").is_stopped()):
		npc = preload("res://scenes/gta/npcgtafps.tscn").instance()
		self.add_child(npc)
		npc.global_transform.origin = where
		justspawn = 1
		npcnear += 1
		get_node("spawndelay").start()
	else:
		return

func _spawncar(where):
	if(get_node("spawndelaycar").is_stopped()):
		car = preload("res://scenes/gta/gtacarfps.tscn").instance()
		self.add_child(car)
		car.global_transform.origin = where
		justspawncar = 1
		carnear += 1
		get_node("spawndelaycar").start()
	else:
		return

func _on_spawndelay_timeout():
	justspawn = 0



func _spawnblood(whereblood,size):
	var _blood2 = _blood.instance()
	self.add_child(_blood2)
	_blood2.global_transform.origin = whereblood
	if(size == "small"):
		_blood2.scale = Vector3(0.5,0.5,0.5)



func _closetextbox():
	get_node("text/Label").modulate= "00ffffff"
	get_node("textspeed").stop()
	get_node("text/Label").visible_characters = -1
	
	
func _openphonetextbox(text, who):
	get_node("text/Label").modulate= "ffffff"
	get_node("text/Label").visible_characters = 0
	get_node("text/Label").set_text(text)
	get_node("textspeed").start()
	talkervoice = get_node("text").cutscenvoice.get(who)
	get_node("text/voice").set_stream(get_node("text").voices.get(talkervoice))



func _opendtextbox(_text):
	get_node("text/Label").modulate= "ffffff"
	get_node("text/Label").visible_characters = 0
	get_node("text/Label").set_text(get_node("text").cutscenetext.get(_text))
	get_node("textspeed").start()
	talkervoice = get_node("text").cutscenvoice.get(_text)
	get_node("text/voice").set_stream(get_node("text").voices.get(talkervoice))

func _on_textspeed_timeout():
	get_node("text/Label").visible_characters +=1
	if(get_node("text/voice").is_playing() == false):
		get_node("text/voice").play()
	if(get_node("text/Label").visible_characters < get_node("text/Label").get_total_character_count()):
			get_node("textspeed").start()











func _startcutscene(which):
	get_node("skip").visible = true
	get_node("KineFPS").visible = false
	get_node("loading/AnimationPlayer").play("load")
	get_node("KineFPS")._showhidehud("hide")
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
	get_node("KineFPS")._showhidehud("show")
	get_node("Camera/Camera").current = true
	get_node("music").stop()
	get_node("text/bg").visible = false
	get_node("text/Label").visible_characters = 0
	get_node("textspeed").stop()
#	get_node("cutscene").get_child(0).find_node("animcutscene").stop()
	started = 1
	minimap = 0
	get_node("KineFPS").visible = true

	get_node("cutscene").get_child(0).queue_free()

func _on_skip_pressed():
	_endcutscene()



func _on_spawndelaycar_timeout():
	justspawncar = 0
