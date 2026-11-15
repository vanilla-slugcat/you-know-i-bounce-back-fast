extends Node2D

@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var area: Area2D = $Area2D

var blockhealth = 0

func _ready() -> void:
	add_to_group("breakable")
	sprite.play("break0")
	area.body_entered.connect(_on_area_2d_body_entered)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func break_block() -> void:
	blockhealth += 1
	if blockhealth >= 3:
		collision_shape.set_deferred("disabled", true)
		sprite.visible = false
		queue_free()
	else:
		sprite.play("block" + str(blockhealth))



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and body.current_state == body.state.SLAM:
		break_block()
