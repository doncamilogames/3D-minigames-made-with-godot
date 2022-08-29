extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_pipo_pressed():
	get_node("macron/AnimationPlayer").play("macronPipeau")


func _on_fuck_pressed():
	get_node("macron/AnimationPlayer").play("fuck")
