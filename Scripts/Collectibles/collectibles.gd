extends Area2D

@export var data: CollectibleData

func _ready() -> void:
	$Sprite2D.texture = data.texture
	$DispawnTimer.wait_time = data.lifetime
	$DispawnTimer.start()

# Handles distribution of incoming Randomized Collectible Data and Goblins Final Position from Goblin
func _on_body_entered(body: CharacterBody2D) -> void:
	if not body.is_in_group("Player"):
		return

	match data.collectibles_type:
		CollectibleData.CollectibleType.LIFE_BOX:
			var World_Scene = get_tree().get_first_node_in_group("World")
			World_Scene.lives += data.effect_amount
			print("1 LIFE UP")
			queue_free()

		CollectibleData.CollectibleType.COFFEE_BOX:
			print("COFFEE BOOST PICKED")
			body.apply_coffee_buff(data.effect_amount, data.effect_duration)
			queue_free()

		CollectibleData.CollectibleType.GUNMOD_BOX:
			print("GUN MOD PICKED")
			body.apply_gun_buff(data.effect_amount, data.effect_duration)
			queue_free()


func _on_dispawn_timer_timeout() -> void:
	queue_free()
