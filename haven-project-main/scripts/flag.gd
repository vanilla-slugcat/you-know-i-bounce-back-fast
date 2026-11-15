extends Node2D

@onready var area: Area2D = $Area2D
@export var spring_velocity = -600

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		area.set_deferred("disabled", true)
		Global._finish_level.call_deferred()
