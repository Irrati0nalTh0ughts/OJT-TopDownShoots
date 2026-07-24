extends Node2D

@onready var ui_hud: UI_HUD = %HUD
@onready var game_menu: CanvasLayer = %GAME_HUD

@onready var bush: TileMapLayer = $MapLayout/Bush
@onready var grass: TileMapLayer = $MapLayout/Grass
@onready var wave_cd: Timer = $WaveCD

@export_category("Stat")
@export var max_spawn: int = 5

var current_wave: int = 1
var current_health: int = 0
var current_ammo: int = 0
var current_goblins: int = 0

var enemies_to_spawn_this_wave: int = 0
var enemies_spawned_this_wave: int = 0

enum GameState { PLAYING, GAME_OVER, NEW_HIGH }
enum WaveState { SPAWNING, ACTIVE, COOLDOWN }

var game_state: GameState = GameState.PLAYING
var wave_state: WaveState = WaveState.SPAWNING


func _ready() -> void:
	bush.add_to_group("wall")


func _on_game_hud_start_game_requested() -> void:
	Start_Wave.call_deferred()


func _on_game_hud_return_to_main_menu_requested() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func Start_Wave() -> void:
	game_state = GameState.PLAYING
	wave_state = WaveState.SPAWNING

	ui_hud.high_cont.visible = false
	ui_hud.game_over.visible = false

	enemies_spawned_this_wave = 0
	enemies_to_spawn_this_wave = current_wave * max_spawn

	await get_tree().process_frame
	Update_UI()

	wave_state = WaveState.ACTIVE


func Update_UI() -> void:
	if ui_hud == null:
		return

	current_goblins = get_tree().get_nodes_in_group("enemies").size()

	print("has UI:", has_node("UI"))
	print("UI node:", get_node_or_null("UI"))
	print("ui_hud:", ui_hud)
	ui_hud.enemy_count.text = " X " + str(current_goblins)
	ui_hud.wave_count.text = "WAVE: " + str(current_wave)
	ui_hud.life_count.text = " X " + str(current_health)
	ui_hud.ammo_count.text = " X " + str(current_ammo)

	if current_health > 0:
		return

	if current_wave >= Autoload.highest_wave:
		Autoload.highest_wave = current_wave
		game_state = GameState.NEW_HIGH
	else:
		game_state = GameState.GAME_OVER

	match game_state:
		GameState.NEW_HIGH:
			ui_hud.hc_high_wave_label.text = "HIGHEST WAVE:\n" + str(Autoload.highest_wave)
			ui_hud.high_cont.visible = true

		GameState.GAME_OVER:
			ui_hud.high_wave_label.text = "HIGHEST WAVE:\n" + str(Autoload.highest_wave)
			ui_hud.game_over.visible = true

	get_tree().paused = true


func _on_spawn_area_a_goblin_died() -> void:
	if game_state != GameState.PLAYING:
		return

	await get_tree().process_frame
	Update_UI()

	var all_spawned_and_cleared := (
		get_tree().get_node_count_in_group("enemies") <= 0
		and enemies_spawned_this_wave >= enemies_to_spawn_this_wave
	)

	if wave_state == WaveState.ACTIVE and all_spawned_and_cleared:
		wave_state = WaveState.COOLDOWN
		current_wave += 1
		ui_hud.next_wave.visible = true
		wave_cd.start()
		await wave_cd.timeout
		Start_Wave()


func _on_wave_cd_timeout() -> void:
	ui_hud.next_wave.visible = false


func _on_player_current_ammo_changed(ammo: int) -> void:
	if game_state != GameState.PLAYING:
		return

	current_ammo = ammo
	Update_UI()


func _on_player_i_lost_a_life(health: int, _max_health: int) -> void:
	if game_state != GameState.PLAYING:
		return

	current_health = health
	Update_UI()


func _on_player_i_died() -> void:
	current_health = 0
	Update_UI()


func _on_ui__hc_restart_bttn() -> void:
	_restart_run()


func _on_ui__restart_bttn() -> void:
	_restart_run()


func _restart_run() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
