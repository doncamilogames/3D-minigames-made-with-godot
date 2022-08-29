extends StaticBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _target():
		get_parent().get_parent().targets += 1
		get_parent().get_parent()._updatehud()
		get_parent().get_parent()._playsound("victory1.wav")
		queue_free()
