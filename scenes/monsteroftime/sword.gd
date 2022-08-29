extends Area
var _owner 

func _ready():
	_owner = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()



func _on_sword_body_entered(body):
	if(body != _owner):
		if(_owner.Animarm.get_current_animation() == "sword"):
			_owner.Animarm.play("Idle")
			if(body.has_method("_sworded")):
				body._sworded()


func _on_sword_area_entered(area):
		if(area.has_method("_sworded")):
			if(_owner.Animarm.get_current_animation() == "sword"):
				area._sworded()
