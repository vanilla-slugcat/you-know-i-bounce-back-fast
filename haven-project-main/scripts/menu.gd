extends Control

@onready var settings_panel: Panel = $settingspanel

func _ready() -> void:
	Hud.visible = false
	Parallax2d.visible = false
	settings_panel.visible = false

func _on_settingsbutton_pressed() -> void:
	settings_panel.visible = !settings_panel.visible

func _on_easy_pressed() -> void:
	Global.set_difficulty(5)
	settings_panel.visible = false

func _on_medium_pressed() -> void:
	Global.set_difficulty(3)
	settings_panel.visible = false

func _on_hard_pressed() -> void:
	Global.set_difficulty(2)
	settings_panel.visible = false

func _on_playbutton_pressed() -> void:
	Global.hearts = Global.max_hearts
	Hud.update_hearts()
	Hud.visible = true
	Parallax2d.visible = true
	Global.level = 1
	get_tree().change_scene_to_file("res://scenes/levels/1.tscn")
