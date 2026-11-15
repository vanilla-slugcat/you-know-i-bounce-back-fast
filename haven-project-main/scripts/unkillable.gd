extends Enemy

@onready var area_2d: Area2D = $Area2D

func _init():
	speed = 60.0
	health = 3

func handle_behavior(_delta):
	if is_on_wall() or ray_cast.is_colliding():
		_perform_flip()

	velocity.x = direction * speed
	animated_sprite.play("default")

func _on_body_entered(body: Node2D) -> void:
	print("enter")
	if body is Player:
		body.take_damage()
