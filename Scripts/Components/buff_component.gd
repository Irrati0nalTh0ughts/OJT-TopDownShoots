extends Node

class_name BuffComponent


@export var stats: StatComponent
@export var player: CharacterBody2D

@onready var coffee_timer: Timer = %Coffee_Duration
@onready var lives_duration_sp: Timer = %Lives_Duration_Sp
@onready var coffee_duration_sp: Timer = %Coffee_Duration_Sp
@onready var gun_duration_sp: Timer = %Gun_Duration_Sp

var original_speed : float
var original_health : float
var bonus_ammo: int
var special_gun_buff_active : bool = false
var special_coffee_buff_active : bool = false
var special_lives_buff_active : bool = false

func _ready() -> void:
	await get_tree().process_frame
	initialize()
	player = $".."

func initialize():
	player = get_parent()
	stats = player.get_node("StatsComponent")
	original_speed = stats.movement_speed

# ------(( LIFE MODS ))------
func apply_life_buff(amount: float) -> void:
	if special_lives_buff_active:
		return
	if amount <= 0:
		return
	stats.modified_stats(amount)

func apply_special_life_buff(amount: float, duration: float) -> void:
	special_lives_buff_active = true
	original_health = stats.current_health
	stats.modified_stats(amount)
	
	lives_duration_sp.wait_time = duration
	lives_duration_sp.start()

# ------(( COFFEE MODS ))------
func apply_coffee_buff(amount: float, duration: float):
	if special_coffee_buff_active:
		return
	stats.movement_speed = original_speed * amount

	coffee_timer.wait_time = duration
	coffee_timer.start()

func apply_special_coffee_buff(amount: float, duration: float) -> void:
	special_coffee_buff_active = true
	Engine.time_scale = amount
	stats.movement_speed = original_speed * 2.5
	
	coffee_duration_sp.wait_time = duration
	coffee_duration_sp.start()

# ------(( GUN MODS ))------
func apply_gun_buff(amount: float):
	bonus_ammo = amount
	player.current_ammo += bonus_ammo
	player.current_ammo_changed.emit(player.current_ammo)
	bonus_ammo = 0

func apply_special_gun_buff(duration: float) -> void:
	special_gun_buff_active = true
	
	gun_duration_sp.wait_time = duration
	gun_duration_sp.start()


func _on_lives_duration_sp_timeout() -> void:
	stats.current_health = original_health
	
	special_lives_buff_active = false
	stats.health_changed.emit(stats.current_health, stats.max_health)


func _on_coffee_duration_timeout() -> void:
	stats.movement_speed = original_speed


func _on_coffee_duration_sp_timeout() -> void:
	Engine.time_scale = 1
	stats.movement_speed = original_speed


func _on_gun_duration_timeout() -> void:
	special_gun_buff_active = false
