extends Node2D

@export var Collectible_Scene: PackedScene

# Reference came from sibling node Enemy Spawner
func _on_spawn_area_a_goblin_was_there(goblin_finalpos: Vector2, collectible_ref: CollectibleData) -> void:
	
	var collectible = Collectible_Scene.instantiate()

	if collectible_ref == null:
		return

	collectible.global_position = goblin_finalpos
	collectible.data = collectible_ref
	
	var World : Node2D = get_tree().current_scene
	World.add_child.call_deferred(collectible)
