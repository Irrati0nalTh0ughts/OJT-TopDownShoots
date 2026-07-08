extends Resource

class_name CollectibleData

enum CollectibleType {
	LIFE_BOX,
	COFFEE_BOX,
	GUNMOD_BOX,
	NOTHING
}

@export var collectibles_type: CollectibleType
@export var lifetime: float
@export var effect_amount: int 
@export var effect_duration: float
@export var texture: Texture2D
