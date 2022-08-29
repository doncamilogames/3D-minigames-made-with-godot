extends Spatial

				#	 FOR ALL CUTSCENES
var mainnode
func _ready():
	mainnode = get_parent().get_parent()
	mainnode.get_node("loading/AnimationPlayer").play("load")
	if(name == "Green1end"):
		if(mainnode.name == "GTATown"):
			get_tree().change_scene("res://scenes/gta/Ghouse1.tscn")
			
			
			
			
			
			
func _closetextbox():

	mainnode._closetextbox()
func _opendtextbox(_text):

	mainnode._opendtextbox(_text)

func _on_textspeed_timeout():

	mainnode._on_textspeed_timeout()
	
func _endcutscene():

	mainnode._endcutscene()

func _startcutscene(which):
#	mainnode = get_tree().current_scene.find_node("GTATown")
	mainnode._startcutscene(which)


func _playeraction(which):
	mainnode._playeraction(which)


func _opendoor(which):
	mainnode._opendoor(which)
