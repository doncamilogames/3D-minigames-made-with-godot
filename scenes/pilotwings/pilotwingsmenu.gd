extends Control

var _level = 1
var _mode = "rings"
var trophies = [1,0,1,0,1,0,1,0,1,0,1,0]
var trophyselected = null
var trophiestext = {
	0 : "Pass through  the 10 rings of the first level in less than 2:00.",
	1 : "Pass through  the 10 rings of the second level in less than 2:00.",
	2 : "Pass through the 10 rings of the third level in less than 2:00.",
	3 : "destroy all the targets of the first level in less than 2:00.",
	4 : "destroy all the targets of the second level in less than 2:00.",
	5 : "destroy all the targets of the third level in less than 2:00.",
	6 : "mode 3 level 1 ?",
	7 : "mode 3 level 2 ?",
	8 : "mode 3 level 3 ?",
	9 : "find the key of the first level.",
	10 : "find the key of the second level.",
	11 : "find the key of the third level.",
}

var leveldesc = {
	1 : "A small island.",
	2 : "A big town.",
	3 : "A frozen archipelago.",
}

func _ready():
	_trophy("0")
	if(Global.pilotswins.modeselected == "rings"):
		_on_Rings_pressed()
	if(Global.pilotswins.modeselected == "targets"):
		_on_targets_pressed()

	if(Global.pilotswins.levelselected == 1):
		_on_level1_pressed()
	if(Global.pilotswins.levelselected == 2):
		_on_level2_pressed()
	if(Global.pilotswins.levelselected == 3):
		_on_level3_pressed()

	_updatescore()
	trophies = Global.pilotswins.trophies
	for i in get_node("trophises").get_child_count():
		if(trophies[i] == 1):
			get_node("trophises").get_child(i).get_node("Sprite").set_self_modulate("ffc500")

func _updatescore():
	var tempscore
	if(_mode == "rings"):
		tempscore = Global.pilotswins.scorerings[_level]
	if(_mode == "targets"):
		tempscore = Global.pilotswins.scoretargets[_level]

	get_node("menu/score").set_text("Best score : " + str(tempscore))
	var minutes
	var seconds
	if(_mode == "rings"):
		seconds = floor(fmod(Global.pilotswins.timerings[_level],60))
		minutes = floor( Global.pilotswins.timerings[_level] / 60)
	if(_mode == "targets"):
		seconds = floor(fmod(Global.pilotswins.timetargets[_level],60))
		minutes = floor( Global.pilotswins.timetargets[_level] / 60)
		
		
	get_node("menu/time").set_text("Best time : " + str(minutes)+":"+ str(seconds))
	
	
	

func _on_Rings_pressed():
	get_node("menu/cursormode").position = get_node("menu/Rings").rect_position
	get_node("menu/descmode").set_text("Find and pass through  the 10 rings.")
	get_node("ViewportContainer/Viewport/Spatial/target").visible = false
	get_node("ViewportContainer/Viewport/Spatial/ring").visible = true
	_mode = "rings"
	Global.pilotswins.modeselected = "rings"
	_updatescore()
func _on_targets_pressed():
	get_node("menu/cursormode").position = get_node("menu/targets").rect_position
	get_node("menu/descmode").set_text("Find and destroy the 10 targets.")
	get_node("ViewportContainer/Viewport/Spatial/target").visible = true
	get_node("ViewportContainer/Viewport/Spatial/ring").visible = false
	_mode = "targets"
	Global.pilotswins.modeselected = "targets"
	_updatescore()
func _on_level1_pressed():
	get_node("menu/cursorlevel").rect_position = Vector2(0,334)
	get_node("menu/desclevel").set_text(leveldesc.get(1))
	_level = 1
	Global.pilotswins.levelselected = 1
	get_node("music").set_stream(load("res://asset/sounds/pilotcave.ogg"))
	get_node("music").play()
	_updatescore()
	var _texture = load("res://asset/textures/hudmenu/pilotlevel1.png")
	get_node("bgs/level").set_texture(_texture)
	
func _on_level2_pressed():
	get_node("menu/cursorlevel").rect_position = Vector2(215,334)
	get_node("menu/desclevel").set_text(leveldesc.get(2))
	Global.pilotswins.levelselected = 2
	_level = 2
	get_node("music").set_stream(load("res://asset/sounds/withbass.ogg"))
	get_node("music").play()
	_updatescore()
	var _texture = load("res://asset/textures/hudmenu/pilotlevel2.png")
	get_node("bgs/level").set_texture(_texture)

func _on_level3_pressed():
	get_node("menu/cursorlevel").rect_position = Vector2(418,334)
	get_node("menu/desclevel").set_text(leveldesc.get(3))
	Global.pilotswins.levelselected = 3
	_level = 3
	get_node("music").set_stream(load("res://asset/sounds/pilotcave.ogg"))
	get_node("music").play()
	_updatescore()
	var _texture = load("res://asset/textures/hudmenu/pilotlevelsnow.png")
	get_node("bgs/level").set_texture(_texture)

func _on_Start_pressed():
	if(_level == 1):
		get_tree().change_scene("res://scenes/pilotwings/pilotwings.tscn")
	if(_level == 2):
		get_tree().change_scene("res://scenes/pilotwings/pilotwings2.tscn")
	if(_level == 3):
		get_tree().change_scene("res://scenes/pilotwings/pilotwingssnow.tscn")

func _on_quit_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")

func _trophy(which):
	get_node("menu/desctrophies").set_text(trophiestext.get(which.to_int()))
	get_node("bgs/cursortroph").position = get_node(str("trophises/" + which)).rect_position

