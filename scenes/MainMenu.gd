extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	get_tree().change_scene("res://scenes/New menu.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_aventure_pressed():
	get_tree().change_scene("res://scenes/Gameexploration.tscn")


func _on_macron_pressed():
	pass
	


func _on_race_pressed():
	pass


func _on_quit_pressed():
	get_tree().quit()


func _on_platforming_pressed():
	get_tree().change_scene("res://scenes/macronbros/towntiled.tscn")


func _on_tube_pressed():
	get_tree().change_scene("res://scenes/tube/tubegame.tscn")


func _on_factory_pressed():
	get_tree().change_scene("res://scenes/factory/factoryslave.tscn")


func _on_pilotwings_pressed():
	get_tree().change_scene("res://scenes/pilotwings/pilotwings.tscn")




func _on_boxe_pressed():
	get_tree().change_scene("res://scenes/boxe/boxescene.tscn")


func _on_moto_button_down():
	get_tree().change_scene("res://scenes/moto/roadrash.tscn")


func _on_pilotwings2_pressed():
	get_tree().change_scene("res://scenes/pilotwings/pilotwings2.tscn")
