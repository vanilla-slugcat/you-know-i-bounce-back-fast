extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@export var spring_velocity = -1200

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.current_state == body.state.SLAM:
			body.change_state(body.state.JUMP)
			body.velocity.y = spring_velocity
			animation.play("bounce")
