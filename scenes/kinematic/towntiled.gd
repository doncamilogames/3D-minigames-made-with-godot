extends Spatial

var started = 0
var score = 0

var closeobject

var npc
var car

var npcnear = 0
var maxnpc = 6
var carnear = 0
var maxcar = 6
var justspawn = 0
var justspawncar = 0
var minimap = 0

onready var _blood = preload("res://scenes/macronbros/blood1.tscn")

func _ready():
	get_node("menu/score/amount").set_text(str(Global.bestgun))
	get_node("nbkilled").set_text("0")
	get_node("Gridtrot").visible = true
	get_node("Gridtrot").visible = false
	get_node("Gridroad").visible = true
	get_node("Gridroad").visible = false
	Global._updateadjworldenv()
func _on_start_pressed():
	get_node("menu").rect_position.y = 600
	started = 1
	score = -2

	get_node("nbkilled").set_text("0")
	get_node("Kinemacron").life = get_node("Kinemacron").lifemax

func _endgame():
	get_node("menu").rect_position.y = 0
	started = 0


func _spawnblood(whereblood):
	var _blood2 = _blood.instance()
	self.add_child(_blood2)
	_blood2.global_transform.origin = whereblood


func _on_quit_pressed():
		get_tree().change_scene("res://scenes/MainMenu.tscn")


func _spawnnpc(where):
	if(get_node("spawndelay").is_stopped()):
		npc = preload("res://scenes/macronbros/npcgta.tscn").instance()
		self.add_child(npc)
		npc.global_transform.origin = where
		justspawn = 1
		npcnear += 1
		get_node("spawndelay").start()
	else:
		return



func _spawncar(where):
	if(get_node("spawndelaycar").is_stopped()):
		car = preload("res://scenes/macronbros/gtacar.tscn").instance()
		self.add_child(car)
		car.global_transform.origin = where
		justspawncar = 1
		carnear += 1
		get_node("spawndelaycar").start()
	else:
		return


		
func _on_spawndelay_timeout():
	justspawn = 0



func _on_minimapbutton_pressed():
	if(started == 1):
		if(minimap == 0):
			minimap = 1
			get_node("minimap/Viewport/Camera2").size = 1000 
			get_node("minimap/Viewport/Camera2").global_transform.origin = Vector3(500,500,500)
			return
		if(minimap == 1):
			minimap = 2
			get_node("minimap").visible = false
			return
		if(minimap == 2):
			minimap = 0
			get_node("minimap").visible = true
			get_node("minimap").rect_position = Vector2(630,440)
			get_node("minimap/pointer").position = Vector2(100,75)
			return


func _on_spawndelaycar_timeout():
	justspawncar = 0
