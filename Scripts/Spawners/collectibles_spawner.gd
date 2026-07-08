extends Node

@export var drop_table : DropTable

func _ready() -> void:
	print(drop_table.DropRNG())
