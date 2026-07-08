extends Area2D

@export var data: CollectibleData

func _ready() -> void:
	$Sprite2D.texture = data.texture
	$DispawnTimer.wait_time = data.lifetime
	$DispawnTimer.start()

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	match data.collectibles_type:
		CollectibleData.CollectibleType.LIFE_BOX:
			var world : Node2D = get_tree().current_scene
			world.lives += data.effect_amount

		CollectibleData.CollectibleType.COFFEE_BOX:
			body.apply_coffee_buff(data.effect_amount, data.effect_duration)

		CollectibleData.CollectibleType.GUNMOD_BOX:
			body.apply_gun_buff(data.effect_amount, data.effect_duration)
