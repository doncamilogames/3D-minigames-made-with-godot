extends Area

var _player
func _ready():
	_player = get_tree().current_scene.find_node("player")




func _on_refill_life_body_entered(body):
	_player._on_refill_life_body_entered(body)


func _on_refill_life_body_exited(body):
	_player._on_refill_life_body_exited(body)
