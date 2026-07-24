extends Resource

class_name DataEntry

enum GoblinType { NONE, BASE, CHARGER }

@export var weight : int

@export_category("Collectibles")
@export var ItemData : CollectibleData

@export_category("Mob Types")
@export var goblin_type : GoblinType
