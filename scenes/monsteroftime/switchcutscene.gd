extends Spatial
var _player
export var switch = ""
var cut
var smallcut = {
	"flower1" : "res://scenes/monsteroftime/cutscenes/flower1.tscn",
	"forestlook" : "res://scenes/monsteroftime/cutscenes/flower1.tscn",
}

func _ready():
	add_to_group(switch)
	_player = get_tree().current_scene.find_node("Kinemonster")
	
func switchreaction():
	if(get_child_count() == 0):
		cut = load(smallcut.get(switch))
		cut = cut.instance()
		add_child(cut)
		_player._showhidehud("hide")
		if(switch == "flower1"):
			_player.railcut = get_node("flower1/Posplayer")
			_player.mode = "onrail"
	else:
		get_child(0).play("cutscene")
		_player._showhidehud("hide")

	_player.Animleg.play("Idle")
	_player.mode = "cutscene"
func deletecut():
	
	_player.mode = ""
	get_child(0).queue_free()
	_player.get_node("Spring/SpringArm/Camera").current = true
	_player._showhidehud("show")
	Global._savegame()
	if(switch == "introcut3"):
		get_parent().get_node("npc/friend1").queue_free()
		get_parent().get_node("npc/friend2").queue_free()
		get_parent().get_node("npc/chief").global_transform.origin = Vector3(99,13.8,-76.3)

	
	
func _opendtextbox(_text):
	get_parent()._opendtextbox(_text)
	
func _closetextbox():
	get_parent()._closetextbox()
	
