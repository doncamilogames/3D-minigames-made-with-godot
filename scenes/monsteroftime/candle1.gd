extends StaticBody


var rng = RandomNumberGenerator.new()
func _ready():
	rng.randomize()
	get_node("AnimationPlayer").playback_speed = rng.randf_range(2.0,3.0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
