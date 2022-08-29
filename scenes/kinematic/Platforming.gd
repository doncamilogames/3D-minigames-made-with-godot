extends Spatial

var started = 0
var score = 0
var justspawn = 0
var closeobject
var npc
var npcnear = 0
onready var _blood = preload("res://scenes/macronbros/blood1.tscn")
func _ready():
	get_node("menu/score/amount").set_text(str(Global.bestgun))
	get_node("nbkilled").set_text("0")
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
	if(justspawn == 0):
		npc = preload("res://scenes/macronbros/npcgta.tscn").instance()
		self.add_child(npc)
		npc.global_transform.origin = where
		justspawn = 1
		npcnear += 1
		get_node("spawndelay").start()
		
func _on_spawndelay_timeout():
	justspawn = 0

