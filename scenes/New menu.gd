extends Spatial

var game = ""
var targetpos
var juke = 0
var currentsong = "Main Menu"
func _ready():
	Global._loadgame()
	Global.currentgame = ""
	Global._on_close_pressed()
	Global._updateadjworldenv()

func _process(_delta):
	if(targetpos != null):
		get_node("Camera").global_transform.origin = lerp(get_node("Camera").global_transform.origin,targetpos,0.05)
		get_node("Camera").look_at(targetpos,Vector3.UP)
		if(get_node("Camera").global_transform.origin.distance_to(targetpos) < 0.22):
			Global.currentgame = game
			Global._on_close_pressed()
			if(game == "hyper"):
				get_tree().change_scene("res://scenes/tube/tubemenu.tscn")
			if(game == "kiri"):
				get_tree().change_scene("res://scenes/kiri/kirimenu.tscn")
			if(game == "pilot"):
				get_tree().change_scene("res://scenes/pilotwings/pilotwingsmenu.tscn")
			if(game == "monster"):
				get_tree().change_scene("res://scenes/monsteroftime/motmenu.tscn")
			if(game == "gta"):
				get_tree().change_scene("res://scenes/gta/gtamenu.tscn")

#			if(game == "boxe"):
#				get_tree().change_scene("res://scenes/boxe/boxescene.tscn")
#			if(game == "road"):
#				get_tree().change_scene("res://scenes/moto/roadrash.tscn")

#			if(game == "rogue"):
#				get_tree().change_scene("res://scenes/roguelike/map1.tscn")


func _on_kiri_input_event(camera, event, position, normal, shape_idx):
	if(targetpos == null):
		if (event  is InputEventScreenTouch ):
			game = "kiri"
			targetpos = get_node("kiri/kiri").global_transform.origin


func _on_pilots_input_event(_camera, event, _position, _normal, _shape_idx):
	if(targetpos == null):
		if (event  is InputEventScreenTouch ):
			game = "pilot"
			targetpos = get_node("pilots/pilot").global_transform.origin


func _on_gta_input_event(_camera, event, _position, _normal, _shape_idx):
	if(targetpos == null):
		if (event  is InputEventScreenTouch ):
			game = "gta"
			targetpos = get_node("gta/gun").global_transform.origin



func _on_hyperd_input_event(_camera, event, _position, _normal, _shape_idx):
	if(targetpos == null):
		if (event  is InputEventScreenTouch ):
			game = "hyper"
			targetpos = get_node("hyperd/hyper").global_transform.origin


func _on_mot_input_event(camera, event, position, normal, shape_idx):
	if(targetpos == null):
		if (event  is InputEventScreenTouch ):
			game = "monster"
			targetpos = get_node("mot/mot").global_transform.origin




func _on_jukebox_input_event(camera, event, position, normal, shape_idx):
		if (event  is InputEventScreenTouch ):
			if(juke == 0 and game == ""):
				juke = 1 
				get_node("AnimationPlayer").play("juke")
				get_node("reset").set_text("Back to games")



func _on_next_input_event(camera, event, position, normal, shape_idx):
	if (event  is InputEventScreenTouch ):
		if(get_node("jukebox/next/delayjuke").is_stopped() == true):
			get_node("jukebox/next/delayjuke").start()
			if(juke == 1):
				var tempsong = Global.gtcradio.keys().find(currentsong) + 1
				if(tempsong > Global.gtcradio.size()-1):
					tempsong = 0
					get_node("music").stop()
					var songplayed = Global.gtcradio.keys()[tempsong]
					songplayed = load(Global.gtcradio.get(songplayed))
					get_node("music").set_stream(songplayed) 
					get_node("music").play()
					currentsong = Global.gtcradio.keys()[tempsong]
					
				else:
					get_node("music").stop()
					var songplayed = Global.gtcradio.keys()[tempsong]
					songplayed = load(Global.gtcradio.get(songplayed))
					get_node("music").set_stream(songplayed) 
					get_node("music").play()
					currentsong = Global.gtcradio.keys()[tempsong]
				get_node("jukebox/sname").set_text(currentsong)




func _on_prev_input_event(camera, event, position, normal, shape_idx):
	if (event  is InputEventScreenTouch ):
		if(get_node("jukebox/next/delayjuke").is_stopped() == true):
			get_node("jukebox/next/delayjuke").start()
			if(juke == 1):
				var tempsong = Global.gtcradio.keys().find(currentsong) -1
				if(tempsong < 0 ):
					tempsong = Global.gtcradio.size()-1
					get_node("music").stop()
					var songplayed = Global.gtcradio.keys()[tempsong]
					songplayed = load(Global.gtcradio.get(songplayed))
					get_node("music").set_stream(songplayed) 
					get_node("music").play()
					currentsong = Global.gtcradio.keys()[tempsong]
					
				else:
					get_node("music").stop()
					var songplayed = Global.gtcradio.keys()[tempsong]
					songplayed = load(Global.gtcradio.get(songplayed))
					get_node("music").set_stream(songplayed) 
					get_node("music").play()
					currentsong = Global.gtcradio.keys()[tempsong]
				get_node("jukebox/sname").set_text(currentsong)










func _on_yes_pressed():
	var dir = Directory.new()
	dir.remove(Global.savename)
	Global.mot = {
	"spawn" : "",
	"changescene" : "",
	"currentweapon":"sword",
	"lastscene" : "",
	"lastspawn" : "",
	"life" : 3,
	"lifemax" : 3,
	"step" : 0,
	"trophies" : [0,0,0,0,0,0,0,0,0,1,1,1],
	"inventory" : ["sword","bow","hook","cursor"],
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
	"switch" : ["test","","",]}#introcut,introcut2,forestlook,snowlook,firelook,introcut3,flower1,rihouse,gridtemple1,loungeswitchget,loungeswitchput,loungedoor, loungeskel, gridtemple1mid

	Global. kiri = {
	"level" : 1,
	"best1" : 0,
	"best2" : 0,
	"best3" : 0,
	"trophies" : [0,0,0,0,0,0,0,0,0,0,0,0],
	"time" : [0,0,0,0,0,0,0,0,0,0,0,0],
	"levelselected" : "1",
	}
	
	Global.pilotswins = {
	"timerings" : [0.0,0.0,0.0],
	"timetargets" : [0.0,0.0,0.0],
	"trophies" : [0,0,0,0,0,0,0,0,0,0,0,0],
	"scorerings" : [0,0,0,0],# first value not used
	"scoretargets" : [0,0,0,0],# first value not used
	"levelselected" : 1,
	"modeselected" : "rings",
	}
	Global.hyperdecagon = {
	"easy" : 0,
	"hard" : 0,
	"vhard" : 0,
	"trophies" : [0,0,0,0,0,0,0,0,0,0,0,0],
	"scorestatic" : [0,0,0,0],# first value not used
	"scoredynamic" : [0,0,0,0],# first value not used
	"levelselected" : 1,
	"modeselected" : "static",
	}
	
	Global.gtc = {
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

	"Gstorycash" : 0,
	"Gstoryinventory" : ["nothing",],
	"Gstorycurrentweapon" : "nothing",
	"Gstorycurrentlife" : 1000,
	"Gstorycurrentcrime" : 0.0,
	"Gstorycurrentarmor" : 0,
	"Gstoryammogun" : 0,
	"Gstoryammomgun" : 0,
	"Gstorystep" : "1g",
	
	"Zombiecash" : 0,
	"Zombieinventory" : ["nothing",],
	"Zombiecurrentweapon" : "nothing",
	"Zombiecurrentlife" : 1000,
	"Zombiegoods" :  ["food","soda","medecine"],
	"Zombiecurrentscene" : "",
	"Zombiecurrentpos" :  [0,0],
	"Zombietime" : 0.0,
	"Zombiecurrentarmor" : 0,
	"Zombiecurrentrun" : 1000,
	"Zombieammogun" : 0,
	"Zombieammomgun" : 0,
	"Zombielastspawn" : "myhouse",
	"radioZombie" : "",
	"Zombieswitch" : [],
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
	"Zombierelativ" : {
		"father" : ["fine","road","home","father1", 1000],  # state, place, destination, objectif, life
		"mother" : ["sick","home","parent","mother1", 1000],  # state, place, destination, objectif, life
		"brother" : ["fine","home","brother","father1", 1000],  # state, place, destination, objectif, life
		"sister" : ["fine","work","","sister1", 1000.0],  # state, place, destination, objectif, life
	},
	
	}
	get_node("reset/yes").visible = false
	get_node("reset/no").visible = false
	get_node("reset").set_text("Reset All Saves")
	


func _on_reset_pressed():
	if(juke == 0):
		get_node("reset").set_text("Are you sure ?")
		get_node("reset/yes").visible = true
		get_node("reset/no").visible = true
	else:
		get_node("AnimationPlayer").play_backwards("juke")
		juke = 0
		get_node("reset").set_text("Reset All Saves")

func _on_no_pressed():
	get_node("reset/yes").visible = false
	get_node("reset/no").visible = false
	get_node("reset").set_text("Reset All Saves")
	



func _on_delayjuke_timeout():
	pass
