extends Enemy

@onready var area_2d: Area2D = $Area2D

var slam_bonus = -1000

func _init():
	speed = 80.0
	health = 3
	coin_count = 1

func handle_behavior(_delta):
	if is_on_wall() or ray_cast.is_colliding():
		_perform_flip()

	velocity.x = direction * speed
	animated_sprite.play("default")

func _on_body_entered(body: Node2D) -> void:
	print("enter")
	if body is Player:
		print("player")
		if body.current_state == body.state.SLAM:
			take_damage(1, body.position)
			body.current_state = body.state.JUMP
			body.velocity.y = slam_bonus
		else:
			body.take_damage()
