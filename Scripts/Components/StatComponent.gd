extends Node

class_name StatComponent

signal health_changed(
	current_health: float, 
	max_health: float
	)
signal you_died


@export var max_health : float = 999
@export var current_health : float
@export var movement_speed : float
@export var damage : float

# INNITIALIZING OF ENTITY STATS	
func initialize_stats(hp: float, spd: float, dmg: float) -> void:
	current_health = hp
	movement_speed = spd
	damage = dmg


func modified_stats(stat_refilled: float) -> void:
	print("I'm it")
	current_health = clamp(
		current_health + stat_refilled, 
		0, max_health
	)
	
	health_changed.emit(current_health, max_health)


func took_damage(dmg: int) -> void:
	current_health = clamp(
		current_health - dmg, 
		0, max_health
	)
	dead()
	health_changed.emit(current_health, max_health)


func dead() -> void:
	if current_health != 0:
		return
		
	you_died.emit()
