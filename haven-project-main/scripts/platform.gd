extends AnimatableBody2D

@export var pointA: float = 10.0   # Left boundary
@export var pointB: float = 100.0  # Right boundary
@export var speed: float = 100.0

var direction: int = 1
var length: int = 32

func _physics_process(delta: float) -> void:
	position.x += speed * direction * delta

	var half_length = length / 2.0

	if position.x + half_length >= pointB and direction == 1: #right edge
		position.x = pointB - half_length  # Prevents overshooting and getting stuck
		direction = -1
	elif position.x - half_length <= pointA and direction == -1: #left edge
		position.x = pointA + half_length
		direction = 1
