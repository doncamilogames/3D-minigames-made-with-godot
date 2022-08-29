extends Node
var volumeglobal = 0.0
var brightnessglobal = 1.0
var contrastglobal = 1.05
var currentgame
var menustate = "close"

var gtc = {
	"modeselected" : "Arcade",
	"trophies" : [0,0,0,0,0,0,0,0,0,0,0,0],
	
	"spawnpoint" : "",
	"spawnpointtown" : "",
	"currentmission" : "",
	"lifemax" : 1000.0,
	"armormax" : 500,
	"ammogunmax" : 50,
	"ammomgunmax" : 200,


	"Arcadecash" : 0,
	"Arcadeinventory" : ["nothing",],
	"Arcadecurrentweapon" : "nothing",
	"Arcadecurrentlife" : 1000,
	"Arcadecurrentcrime" : 0.0,
	"Arcadecurrentarmor" : 0,
	"Arcadeammogun" : 0,
	"Arcadeammomgun" : 0,
	"Arcadelastspawn" : "",
	"radioarcade" : "",
	"Arcadeenemies" : {
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
		"R4" : 6,},

	"Gstorycash" : 0,
	"Gstoryinventory" : ["nothing",],
	"Gstorycurrentweapon" : "nothing",
	"Gstorycurrentlife" : 1000,
	"Gstorycurrentcrime" : 0.0,
	"Gstorycurrentarmor" : 0,
	"Gstoryammogun" : 0,
	"Gstoryammomgun" : 0,
	"Gstorystep" : "1g",
	
	"Zombiecurrentscene" : "res://scenes/gta/building2fps.tscn",
	"Zombiecash" : 0,
	"Zombieinventory" : ["nothing"],
	"Zombiegoods" : ["food","soda","medecine"],#food, soda, medecine, family member escorted ?
	"Zombiecurrentweapon" : "nothing",
	"Zombiecurrentlife" : 1000,
	"Zombiecurrentpos" : [0,0],
	"Zombiecurrentarmor" : 0,
	"Zombiecurrentrun" : 1000,
	"Zombieammogun" : 50,
	"Zombieammomgun" : 200,
	"Zombielastspawn" : "myhouse",
	"radioZombie" : "",
	"Zombietime" : 0.0,  # 10780 = 1h , 14380 = 2h , 2500 = 23h
	"Zombierelativ" : {
		"father" : ["fine","road","home","father1", 1000.0],  # state, place, destination, objectif, life1
		"mother" : ["sick","home","parent","mother1", 1000.0],  # state, place, destination, objectif, life
		"brother" : ["fine","home","brother","brother1", 1000.0],  # state, place, destination, objectif, life
		"sister" : ["fine","work","","sister1", 1000.0],  # state, place, destination, objectif, life
	},
	"Zombieswitch" : [],#intro1, 1stcallparents, 1stcallsister, 1stcallbrother, portescorted    #all chest and fridge with unic name , family member step, cutscenes, ...wall2... 
	}
var gtanpc = {
	"Ywoman" : [2,"res://asset/materials/clothnpc5.tres","res://scenes/gta/npc/faceF1.tres","res://asset/materials/hairblond.tres"], #gender,cloth, head,hair
	"Gplayer" : [1,"res://asset/materials/clothnpc2.tres","res://scenes/gta/npc/faceM1.tres","res://asset/materials/hairbrown.tres"], #gender,cloth, head,hair
	"Gcousin" : [1,"res://asset/materials/clothnpc1.tres","res://scenes/gta/npc/faceM3.tres","res://asset/materials/hairblond.tres"], #gender,cloth, head,hair
	"arcade" : [1,"res://asset/materials/clotharcade.tres","res://scenes/gta/npc/facearcade.tres","res://asset/materials/hairbrown.tres"], #gender,cloth, head,hair

	"mayor" : [1,"res://asset/materials/clothnpc2.tres","res://scenes/gta/npc/facearcade.tres","res://asset/materials/hairbrown.tres"], #gender,cloth, head,hair
	"assistant" : [1,"res://asset/materials/clothnpc1.tres","res://scenes/gta/npc/faceM1.tres","res://asset/materials/hairbrown.tres"], #gender,cloth, head,hair
	"cop" : [1,"res://asset/materials/clothnpccop.tres","res://scenes/gta/npc/facearcade.tres","res://asset/materials/hairbrown.tres"], #gender,cloth, head,hair

	"brother" : [1,"res://asset/materials/clothnpc6.tres","res://scenes/gta/npc/faceM6.tres","res://asset/materials/hairbrown.tres"], #gender,cloth, head,hair
	"father" : [1,"res://asset/materials/clotharcade.tres","res://scenes/gta/npc/faceM1.tres","res://asset/materials/hairbrown.tres"], #gender,cloth, head,hair
	"mother" : [1,"res://asset/materials/clothnpc1.tres","res://scenes/gta/npc/faceF1.tres","res://asset/materials/hairblond.tres"], #gender,cloth, head,hair
	"sister" : [1,"res://asset/materials/clothnpc5.tres","res://scenes/gta/npc/faceF2.tres","res://asset/materials/hairblond.tres"], #gender,cloth, head,hair
}

var gtcradio = {
	"Main Menu" : "res://asset/sounds/Menu2speedup.ogg",
	
	"Space Song" : "res://asset/sounds/songspace1.ogg",
	"Town Theme" : "res://asset/sounds/withbass.ogg",
	"Moto Ride" : "res://asset/sounds/moto1.ogg",
	
	"Cave Pilot" : "res://asset/sounds/pilotcave.ogg",
	
	"Falling Theme" : "res://asset/sounds/arcadetheme.ogg",
	"Zombie Theme" : "res://asset/sounds/zombie2.ogg",
	"Zombie 1" : "res://asset/sounds/zombie1.ogg",
	"Zombie 2" : "res://asset/sounds/zombie3.ogg",
	"Apocalypse Begins" : "res://asset/sounds/zombie4.ogg",
	
	"Friendly Forest" : "res://asset/sounds/kuru.ogg",
	"Friendly Snow" : "res://asset/sounds/kurulast.ogg",
	"Rainbow Song" : "res://asset/sounds/kuru2.ogg",

	"Humoresk N°1" : "res://asset/sounds/titlemot.ogg",
	"Mysterious Beach" : "res://asset/sounds/beach.ogg",
	"Calm House" : "res://asset/sounds/house1.ogg",
	"Forest" : "res://asset/sounds/wm1forested.ogg",
	
	
}



var hyperdecagon = {
	"easy" : 0,
	"hard" : 0,
	"vhard" : 0,
	"trophies" : [0,0,0,0,0,0,0,0,0,0,0,0],
	"scorestatic" : [0,0,0,0],# first value not used
	"scoredynamic" : [0,0,0,0],# first value not used
	"levelselected" : 1,
	"modeselected" : "static",
	}

var pilotswins = {
	"timerings" : [99,0.0,0.0,0.0],# first value not used
	"timetargets" : [99,0.0,0.0,0.0],# first value not used
	"trophies" : [0,0,0,0,0,0,0,0,0,0,0,0],
	"scorerings" : [99,0,0,0],# first value not used
	"scoretargets" : [99,0,0,0],# first value not used
	"levelselected" : 1,
	"modeselected" : "rings",
	}

var kiri = {
	"level" : 1,
	"best1" : 0,
	"best2" : 0,
	"best3" : 0,
	"trophies" : [0,0,0,0,0,0,0,0,0,0,0,0],
	"time" : [0,0,0,0,0,0,0,0,0,0,0,0],
	"levelselected" : "1",
	}

var mot = {
	"spawn" : "",
	"changescene" : "",
	"currentweapon":"sword",
	"lastscene" : "",
	"lastspawn" : "",
	"life" : 3,
	"lifemax" : 3,
	"step" : 0,
	"trophies" : [0,0,0,0,0,0,0,0,0,0,0,0],
	"inventory" : ["sword","bow","hook"],
	"stuff" : ["cash","skull"],
	"stones" : [],


	"poh" : 0,
	"money" : 0,
	"skull" : 0,

	"arrows" : 10,
	"arrowsmax" : 20,
	
	"pohswitch" : [],#beachruin,beachcave, rihousewater,forest1nearhouse,forest2ontree
	"places" : ["Beach",],#Forest 1 , Forest 2 , Patrick Manor , Forest Caves
	"dooropened" : [],#templekitchen, 
	"switch" : ["test",],#introcut,introcut2,forestlook,snowlook,firelook,introcut3,flower1,rihouse,gridtemple1,loungeswitchget,loungeswitchput,loungedoor, loungeskel, gridtemple1mid
}


var savenameandroid = "user://doncamilogamessavefile" 
var savenamepc = "res://doncamilogamessavefile" 

var savename

func _ready():
	if(OS.get_name() == "Android"):
		savename  = savenameandroid
		
	else:
		savename = savenamepc


func _save():
	var savedict = {
		"hyperdecagon" : hyperdecagon,
		"pilotswins" : pilotswins,
		"kiri" : kiri,
		"mot" : mot,
		"gta" : gtc,
	}
	return savedict
	
func _savegame():
	var save_game = File.new()
	save_game.open(savename, File.WRITE)
	var data = _save()
	save_game.store_line(to_json(data))
	save_game.close()
	print("save")

func _loadgame():
	var save_game = File.new()
	if not save_game.file_exists(savename):
		return#save don't exist
	
	save_game.open(savename,File.READ)
	while save_game.get_position() < save_game.get_len():
		var data = parse_json(save_game.get_line())
	#	print( data)

		gtc = data.gta
		hyperdecagon = data.hyperdecagon
		pilotswins = data.pilotswins
		kiri = data.kiri
		mot = data.mot
	print("load")



func _resetzombiesave():
	gtc.Zombiecash = 0
	gtc.Zombieinventory =  ["nothing",]
	gtc.Zombiecurrentweapon = "nothing"
	gtc.Zombiecurrentlife = 1000
	gtc.Zombiecurrentrun = 1000
	gtc.Zombiecurrentarmor = 0
	gtc.Zombieammogun = 0
	gtc.Zombieammomgun = 0
	gtc.Zombielastspawn = "myhouse"
	gtc.Zombietime = 0.0
	gtc.Zombiecurrentpos = [0,0]
	gtc.Zombiecurrentscene = ""
	gtc.Zombiegoods = []
	gtc.radioZombie = ""
	gtc.Zombieswitch = []
	gtc.Zombierelativ ={
			"father" : ["fine","road","home","father1", 1000],  # state, place, destination, objectif, life
			"mother" : ["sick","home","","mother1", 1000],  # state, place, destination, objectif, life
			"brother" : ["fine","road","port","father1", 1000],  # state, place, destination, objectif, life
			"sister" : ["fine","road","home","father1", 1000],  # state, place, destination, objectif, life
			}





func _on_Volume_value_changed(value):
	AudioServer.set_bus_volume_db(0,value)
	volumeglobal = value
	get_node("Options/settingsmenu/Volume/amount").set_text(str(volumeglobal))

func _on_Brightness_value_changed(value):
	get_tree().current_scene.find_node("WorldEnvironment").environment.set_adjustment_brightness(value)
	brightnessglobal = value
	get_node("Options/settingsmenu/Brightness/amount").set_text(str(brightnessglobal))



func _updateadjworldenv():
	get_tree().current_scene.find_node("WorldEnvironment").environment.set_adjustment_brightness(brightnessglobal)
	AudioServer.set_bus_volume_db(0,volumeglobal)
	get_node("Options/settingsmenu/Volume/amount").set_text(str(volumeglobal))
	get_node("Options/settingsmenu/Brightness/amount").set_text(str(brightnessglobal))



func _on_settings_pressed():
	get_node("Options/settings").visible = false
	get_node("Options/quit").visible = false
	get_node("Options/settingsmenu").visible = true
	menustate = "settings"

func _on_quit_pressed():
	get_node("Options/settings").visible = false
	get_node("Options/quit").visible = false
	get_node("Options/quitmenu").visible = true
	get_node("Options/quitmenu/reset").visible = true
	get_node("Options/quitmenu/menu").visible = true
	if(currentgame == ""):
		get_node("Options/quitmenu/reset").visible = false
		get_node("Options/quitmenu/menu").visible = false
	menustate = "quit"
	

func _on_close_pressed():
	if(menustate == "open"):
		get_node("Options").visible = false
		menustate = "close"
		
	if(menustate == "quit" or menustate == "settings"):
		get_node("Options/settingsmenu").visible = false
		get_node("Options/quitmenu").visible = false
		get_node("Options/settings").visible = true
		get_node("Options/quit").visible = true
		menustate = "open"
		
func _on_open_pressed():
	get_node("Options").visible = true
	menustate = "open"

func _on_menu_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_exit_pressed():
	get_tree().quit()


func _on_reset_pressed():
			if(currentgame == "hyper"):
				get_tree().change_scene("res://scenes/tube/tubemenu.tscn")
			if(currentgame == "gta"):
				get_tree().change_scene("res://scenes/gta/gtamenu.tscn")
			if(currentgame == "pilot"):
				get_tree().change_scene("res://scenes/pilotwings/pilotwingsmenu.tscn")
			if(currentgame == "boxe"):
				get_tree().change_scene("res://scenes/boxe/boxescene.tscn")
#			if(game == "road"):
#				get_tree().change_scene("res://scenes/moto/roadrash.tscn")
			if(currentgame == "kiri"):
				get_tree().change_scene("res://scenes/kiri/kirimenu.tscn")
			if(currentgame == "monster"):
				get_tree().change_scene("res://scenes/monsteroftime/motmenu.tscn")
			if(currentgame == "rogue"):
				get_tree().change_scene("res://scenes/roguelike/maprand.tscn")


