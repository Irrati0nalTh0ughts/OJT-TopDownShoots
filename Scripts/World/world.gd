extends Node2D

@export_category("PackedScenes")
@export var Spawner : PackedScene
@export var Player : PackedScene
@export var Enemy : PackedScene

@export_category("Stat")
@export var max_spawn : int = 5
@export var lives : int = 3

enum GameState { PLAYING, GAME_OVER, NEW_HIGH }

@onready var game_state : GameState = GameState.PLAYING

var current_wave : int
var current_lives : int
var current_goblins : int

var enemies_to_spawn_this_wave: int
var enemies_spawned_this_wave: int
var enemies_alive: int

func Start_Wave() -> void:
	$UI/HUD/High.visible = false
	$UI/HUD/GameOver.visible = false
	
	enemies_spawned_this_wave = 0
	enemies_to_spawn_this_wave = current_wave * max_spawn
	Update_UI()

func Update_UI() -> void:
	current_goblins = get_tree().get_nodes_in_group("enemies").size()
	$UI/HUD/PlayerUi/EnemyCount.text = " X " + str(current_goblins)
	$UI/HUD/PlayerUi/WaveCount.text = "WAVE: " + str(current_wave)
	
	current_lives = lives
	if lives > 0:
		$UI/HUD/PlayerUi/LifeCount.text = " X " + str(current_lives)
	elif lives == 0:
		if current_wave >= Autoload.highest_wave:
			Autoload.highest_wave = current_wave
			print("New High")
			game_state = GameState.NEW_HIGH
			$UI/HUD/High/HighPanel/HighWaveLabel.text = "HIGHEST WAVE:\n" + str(Autoload.highest_wave)
			$UI/HUD/High.visible = true
		elif current_wave < Autoload.highest_wave:
			game_state = GameState.GAME_OVER
			$UI/HUD/GameOver/GameOverPanel/HighWaveLabel.text = "HIGHEST WAVE:\n" + str(Autoload.highest_wave)
			$UI/HUD/GameOver.visible = true
		get_tree().paused = true

func _ready() -> void:
	$MapLayout/Bush.add_to_group("wall")

	current_wave = 1

	Start_Wave()

func _on_restart_bttn_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_spawn_area_a_goblin_died() -> void:
	await get_tree().process_frame
	Update_UI()
	
	if get_tree().get_node_count_in_group("enemies") <= 0 \
	and enemies_spawned_this_wave >= enemies_to_spawn_this_wave:
		current_wave += 1
		$UI/HUD/NextWave.visible = true
		$WaveCD.start()
		await $WaveCD.timeout
		Start_Wave()


func _on_wave_cd_timeout() -> void:
	$UI/HUD/NextWave.visible = false


func _on_player_i_got_hit(damage: int) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	lives -= damage
	var screen_size : Vector2 = get_viewport_rect().size
	player.position = screen_size / 2
	await get_tree().process_frame
	Update_UI()
