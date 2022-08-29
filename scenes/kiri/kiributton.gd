extends TouchScreenButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if(Global.kiri.level < str2var(name)):
		self_modulate = "ff0000"

	elif(Global.kiri.level == str2var(name)):
		self_modulate = "d9ff00"
	else:
		self_modulate = "00ff28"


func _on_kiributton_pressed():
	get_parent().get_parent().get_parent()._on_kiributton_pressed(name)
