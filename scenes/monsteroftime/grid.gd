extends StaticBody
export var switch = ""
export var cutscene = "no"
var state = 0
var _player
func _ready():
	_player = get_tree().current_scene.find_node("Kinemonster")
	add_to_group(switch)
	if(Global.mot.switch.find(switch) != -1):
		get_node("AnimationPlayer").play("openspawn")
		state = 1
		
		
		
		
		
func switchreaction():
		if(state == 0):
			if(cutscene == "no"):
				get_node("AnimationPlayer").play("open")
				_player._playsound("grid")
				state = 1
			else:

				get_node("AnimationPlayer").play("opencutscene")
				state = 1
		else:
			if(cutscene == "no"):
				get_node("AnimationPlayer").play_backwards("open")
				_player._playsound("grid")
				state = 0
			else:
				get_node("AnimationPlayer").play("closecutscene")
				state = 0

func _sound(what):
	if(what == "grid"):
		_player._playsound("biggrid")
	if(what == "boom"):
		_player._playsound("boom")

func _showhidehud(what):
	_player._showhidehud(what)
