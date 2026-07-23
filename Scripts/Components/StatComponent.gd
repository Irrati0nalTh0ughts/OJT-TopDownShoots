extends Node

class_name StatComponent

signal health_changed(current_health: float, max_health: float)
signal you_died


@export var max_health : float
@export var current_health : float
@export var movement_speed : float
@export var damage : float

# INNITIALIZING OF ENTITY STATS	
func initialize_stats(hp: float, spd: float, dmg: float) -> void:
	max_health = hp
	current_health = max_health
	movement_speed = spd
	damage = dmg


func modified_stats(stat_refilled: float) -> void:
	current_health = clamp(
		current_health + (stat_refilled / 2), 
		0, max_health
	)
	
	health_changed.emit(current_health, max_health)


func took_damage(damage: int) -> void:
	current_health = clamp(
		current_health - damage, 
		0, max_health
	)
	print_debug(damage)
	dead()
	health_changed.emit(current_health, max_health)


func dead() -> void:
	if current_health != 0:
		return
		
	you_died.emit()
