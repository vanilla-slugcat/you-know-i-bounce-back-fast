extends Node

var level = 1 
var max_hearts = 3
var hearts: int = 3
var coins = 0
var total_coins = 100

func _finish_level() -> void:
	await Fade.play("fade_out")
	level += 1
	get_tree().change_scene_to_file("res://scenes/levels/" + str(Global.level) + ".tscn")
	await Fade.play("fade_in")
func set_difficulty(heart_ammount: int) -> void:
	max_hearts = heart_ammount
	hearts = heart_ammount
