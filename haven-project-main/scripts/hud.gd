extends CanvasLayer

@onready var heart_nodes: Array[AnimatedSprite2D] = [
	$Heart1,
	$Heart2,
	$Heart3,
	$Heart4,
	$Heart5
]

func _ready() -> void:
	$Label.text = str(Global.coins)
	update_hearts()

func updateCoins() -> void:
	$Label.text = str(Global.coins) + "/" + str(Global.total_coins)
	# You got to have a score out of a number of acorns the entire game has eg. 100

func update_hearts() -> void:
	for i in range(heart_nodes.size()):
		if i < Global.max_hearts:
			heart_nodes[i].visible = true
			if i < Global.hearts:
				heart_nodes[i].play("full")
			else:
				heart_nodes[i].play("empty")
		else:
			heart_nodes[i].visible = false
