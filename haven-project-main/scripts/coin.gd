extends Area2D

@onready var sfxplayer: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	animated_sprite.visible = false
	collision_shape.set_deferred("disabled", true)
	Global.coins += 1
	Hud.updateCoins()
	sfxplayer.play()

	await sfxplayer.finished
	queue_free()
