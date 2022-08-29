extends Button



func _ready():
	pass 



func _on_trophy_pressed():
	get_parent().get_parent()._trophy(name)
