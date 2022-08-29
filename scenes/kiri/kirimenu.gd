extends Control

var _level = 5
var _levelselected = 1
var _mode = ""
var trophies = [1,0,1,0,1,0,1,0,1,0,1,0]
var trophyselected = null
var trophiestext = {
	0 : "Finish level 1 without being hitted!",
	1 : "Finish level 2 without being hitted!",
	2 : "Finish level 3 without being hitted!",
	3 : "Finish level 4 without being hitted!",
	4 : "Finish level 5 without being hitted!",
	5 : "Finish level 6 without being hitted!",
	6 : "Finish level 7 without being hitted!",
	7 : "Finish level 8 without being hitted!",
	8 : "Finish level 9 without being hitted!",
	9 : "Finish level 10 without being hitted!",
	10 : "Finish level 11 without being hitted!",
	11 : "Finish level 12 without being hitted!",
}

var leveldesc = {
	1 : "5 / 10 obstacles.",
	2 : "A mix of easy and hard.",
	3 : "7 / 10 obstacles.",
}

func _ready():
	
	
	_level = Global.kiri.level
	_levelselected = _level
	_on_kiributton_pressed(Global.kiri.levelselected)
	_updatescore()
	trophies = Global.kiri.trophies
	for i in get_node("trophises").get_child_count():
		if(trophies[i] == 1):
			get_node("trophises").get_child(i).get_node("Sprite").set_self_modulate("ffc500")
	_trophy("0")

func _on_kiributton_pressed(which):
	if(str2var(which) <= _level):
		_levelselected = str2var(which)
		Global.kiri.levelselected = which
		_updatescore()
		


func _updatescore():
	get_node("menu/desclevel").set_text("Level : " +  str(_levelselected))
	get_node("menu/score").set_text("Best time : 00:" +  str(Global.kiri.time[_levelselected -1]))
	get_node("menu/bird").global_position = get_node("menu/level/" + str(_levelselected)).global_position + Vector2(16,0)


func _on_Start_pressed():

		get_tree().change_scene("res://scenes/kiri/level" +str(_levelselected) +".tscn")
		
func _on_quit_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")

func _trophy(which):
	get_node("menu/desctrophies").set_text(trophiestext.get(which.to_int()))
	get_node("bgs/cursortroph").position = get_node(str("trophises/" + which) ).rect_position




