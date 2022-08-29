extends Spatial
var atack = 0
func _ready():
	pass


func _swordattack():
	get_parent()._swordattack()


func _on_hand_body_entered(body):
	get_parent()._on_hand_body_entered(body)


func die():
	get_parent().dying()



func fall():
	get_parent().fall()
