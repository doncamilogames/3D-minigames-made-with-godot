extends Spatial
var atack = 0
func _ready():
	pass
func _on_hookblade_body_entered(body):
	if(get_parent().name == "Kinemonster"):
		get_parent()._on_hookblade_body_entered(body)




func _on_blade_body_entered(body):
	if(get_parent().name == "Kinemonster"):
		get_parent()._on_hookblade_body_entered(body)

func _swordattack():
	get_parent()._swordattack()
