extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _shooted(amount):
	get_parent().get_parent().get_parent().get_parent()._getshooted(amount)
func _sworded():

	get_parent().get_parent().get_parent().get_parent()._sworded()
