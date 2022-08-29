extends Control


var trophies = [0,0,0,0,0,0,0,0,0,0,0,0]
var trophyselected = null
var trophiestext = {
	0 : "Temple 1 finished",
	1 : "Temple 2 finished",
	2 : "Temple 3 finished",
	3 : "Story finished",
	4 : "Find 10 things",
	5 : "Find 20 things",
	6 : "Find all things",
	7 : "Find all hearts",
	8 : "Find a secret?",
	9 : "Score in minigame?",
	10 : "Score in minigame?",
	11 : "Secret ending?",
}
func _ready():
	get_node("ViewportContainer/Viewport/Spatial/sagnol/mesh/leg").play("Idleanimated")
	get_node("ViewportContainer/Viewport/Spatial/chief/mesh/leg").play("Idleanimated")
	get_node("ViewportContainer/Viewport/Spatial/friend1/mesh/leg").play("Idleanimated")
	get_node("ViewportContainer/Viewport/Spatial/friend2/mesh/leg").play("Idleanimated")
	trophies = Global.mot.trophies
	for i in get_node("trophises").get_child_count():
		if(trophies[i] == 1):
			get_node("trophises").get_child(i).get_node("Sprite").set_self_modulate("ffc500")
	_trophy("0")


func _trophy(which):
	get_node("menu/desctrophies").set_text(trophiestext.get(which.to_int()))
	get_node("bgs/cursortroph").position  = get_node(str("trophises/" + which)).rect_position



func _on_quit_pressed():
	get_tree().change_scene("res://scenes/New menu.tscn")


func _on_start_pressed():
	if(Global.mot.lastscene != ""):
		var scenepath = "res://scenes/monsteroftime/" + Global.mot.lastscene  +  ".tscn"
		get_tree().change_scene(scenepath) 
	else:
		get_tree().change_scene("res://scenes/monsteroftime/boatinside.tscn") #boatinside


func _on_Delete_pressed():
	pass
