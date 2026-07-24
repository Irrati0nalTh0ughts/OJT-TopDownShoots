extends Node

class_name BuffComponent


@export var stats: StatComponent
@export var player: CharacterBody2D

@onready var coffee_timer: Timer = $CoffeeTimer
@onready var gun_timer: Timer = $GunTimer

var base_speed : float
var bonus_ammo: int
var special_gun_buff_active : bool = false

func _ready() -> void:
	await get_tree().process_frame
	initialize()

func initialize():
	player = get_parent()
	stats = player.get_node("StatsComponent")
	base_speed = stats.movement_speed

func apply_coffee_buff(amount: float, duration: float):
	stats.movement_speed = base_speed * amount

	coffee_timer.wait_time = duration
	coffee_timer.start()

func apply_gun_buff(amount: float):
	bonus_ammo = amount
	player.current_ammo += bonus_ammo
	bonus_ammo = 0

func apply_special_gun_buff(duration: float) -> void:
	special_gun_buff_active = true
	
	gun_timer.wait_time = duration
	gun_timer.start()


func _on_coffee_duration_timeout() -> void:
	stats.movement_speed = base_speed


func _on_gun_duration_timeout() -> void:
	special_gun_buff_active = false
