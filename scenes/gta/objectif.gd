extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_objectif_body_entered(body):
		if(body.has_method("_on_J2_pressed")):
			if(Global.gtc.get("modeselected") == "Gstory"):
				get_parent().get_parent().get_parent().get_parent()._updatemission("progress",Global.gtc.get("Gstorystep"))
				get_parent().get_parent().get_parent().get_parent().get_node("loading/AnimationPlayer").play_backwards("load")
