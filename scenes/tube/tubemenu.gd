extends Control

var _level = 1
var _mode = "static"
var trophies = [1,0,1,0,1,0,1,0,1,0,1,0]
var trophyselected = null
var trophiestext = {
	0 : "Reach 100 in Easy Static.",
	1 : "Reach 85 in Medium Static.",
	2 : "Reach 75 in Hard Static.",
	3 : "Reach 100 in Easy Dynamic.",
	4 : "Reach 85 in Medium Dynamic",
	5 : "Reach 75 in Hard Dynamic",
	6 : "Reach 120 in Easy Static.",
	7 : "Reach 110 in Medium Static.",
	8 : "Reach 100 in hard Static.",
	9 : "Reach 140 in Easy Dynamic.",
	10 : "Reach 120 in Medium Dynamic.",
	11 : "Reach 110 in Hard Dynamic",
}

var leveldesc = {
	1 : "5 / 10 obstacles.",
	2 : "A mix of easy and hard.",
	3 : "7 / 10 obstacles.",
}

var uvpos = 0
var speedtemp = 0.5

func _process(delta):
	uvpos -= speedtemp / 10
	if(uvpos <= -1000):
		uvpos = 0
	get_node("ViewportContainer/Viewport/Spatial/tube").get_surface_material(0).set_uv1_offset(Vector3(0,uvpos,0))
	


func _ready():
	var _mat = load("res://scenes/tube/tube1.tres")
	get_node("ViewportContainer/Viewport/Spatial/tube").set_surface_material(0,_mat)
	Global.hyperdecagon.modeselected = "static"
	Global.hyperdecagon.levelselected = 1
	_updatescore()
	get_node("music").play()
	trophies = Global.hyperdecagon.trophies
	for i in get_node("trophises").get_child_count():
		if(trophies[i] == 1):
			get_node("trophises").get_child(i).get_node("Sprite").set_self_modulate("ffc500")
	_trophy("0")

func _updatescore():
	var tempscore
	if(_mode == "static"):
		tempscore = Global.hyperdecagon.scorestatic[_level]
	get_node("menu/score").set_text("Best score : " + str(tempscore))
	if(_mode == "dynamic"):
		tempscore = Global.hyperdecagon.scoredynamic[_level]
	get_node("menu/score").set_text("Best score : " + str(tempscore))

func _on_Start_pressed():
		get_tree().change_scene("res://scenes/tube/tubegame.tscn")

		
		
func _on_quit_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")

func _trophy(which):
	get_node("menu/desctrophies").set_text(trophiestext.get(which.to_int()))
	get_node("bgs/cursortroph").position = get_node(str("trophises/" + which)).rect_position



func _on_easy_pressed():
	get_node("menu/cursorlevel").rect_position = Vector2(583,71)
	get_node("menu/desclevel").set_text(leveldesc.get(1))
	get_node("music").set_stream(load("res://asset/sounds/songspace1.ogg"))
	get_node("music").play()
	var _mat = load("res://scenes/tube/tube1.tres")
	get_node("ViewportContainer/Viewport/Spatial/tube").set_surface_material(0,_mat)
	_level = 1
	Global.hyperdecagon.levelselected = 1
	_updatescore()
func _on_medium_pressed():
	get_node("menu/cursorlevel").rect_position = Vector2(722,71)
	get_node("menu/desclevel").set_text(leveldesc.get(2))
	get_node("music").set_stream(load("res://asset/sounds/moto1.ogg"))
	get_node("music").play()
	var _mat = load("res://scenes/tube/tube2.tres")
	get_node("ViewportContainer/Viewport/Spatial/tube").set_surface_material(0,_mat)
	_level = 2
	Global.hyperdecagon.levelselected = 2
	_updatescore()
func _on_hard_pressed():
	get_node("menu/cursorlevel").rect_position = Vector2(886,71)
	get_node("menu/desclevel").set_text(leveldesc.get(3))
	get_node("music").set_stream(load("res://asset/sounds/kuru2.ogg"))
	get_node("music").play()
	var _mat = load("res://scenes/tube/tube3.tres")
	get_node("ViewportContainer/Viewport/Spatial/tube").set_surface_material(0,_mat)
	Global.hyperdecagon.levelselected = 3
	_level = 3
	_updatescore()


func _on_static_pressed():
	get_node("menu/cursormode").rect_position = Vector2(607,192)
	get_node("menu/descmode").set_text("Go forward and avoid obstacles!")
	_mode = "static"
	Global.hyperdecagon.modeselected = "static"
	_updatescore()
	get_node("ViewportContainer/Viewport/Spatial/Animtube").stop()

func _on_dynamic_pressed():
	get_node("menu/cursormode").rect_position = Vector2(828,192)
	get_node("menu/descmode").set_text("Go forward, avoid obstacles and manage the rotation of the Tube !")
	_mode = "dynamic"
	Global.hyperdecagon.modeselected = "dynamic"
	_updatescore()
	get_node("ViewportContainer/Viewport/Spatial/Animtube").play("turn")
