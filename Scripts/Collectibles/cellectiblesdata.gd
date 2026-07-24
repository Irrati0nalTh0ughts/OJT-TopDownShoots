extends Resource

class_name CollectibleData

enum CollectibleType {
	LIFE_BOX,
	COFFEE_BOX,
	GUNMOD_BOX,
	SPECIAL_LIFE_BOX,
	SPECIAL_COFFEE_BOX,
	SPECIAL_GUNMOD_BOX
}

@export var collectibles_type: CollectibleType
@export var lifetime: float
@export var effect_amount: float
@export var effect_duration: float
@export var texture: Texture2D
