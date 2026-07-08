extends Node2D

@export var Collectible_Scene: PackedScene

#func _ready() -> void:

func _on_spawn_area_a_goblin_was_there(goblin_finalpos: Vector2, collectible_ref: CollectibleData) -> void:
	
	var collectible = Collectible_Scene.instantiate()

	if collectible_ref == null:
		return

	collectible.global_position = goblin_finalpos
	collectible.data = collectible_ref
	
	get_parent().add_child(collectible)
