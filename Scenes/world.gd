extends Node2D

@export_category("PackedScenes")
@export var HUD : PackedScene
@export var Spawner : PackedScene
@export var Player : PackedScene
@export var Enemy : PackedScene

@export_category("Stat")
@export var max_spawn : int = 5

enum GameState { PLAYING, GAME_OVER, NEW_HIGH }

var lives : int = 3
var waves : int
var goblins : int

var current_wave : int
var current_lives : int
var current_goblins : int

var enemies_to_spawn_this_wave: int
var enemies_spawned_this_wave: int
var enemies_alive: int

@onready var game_state = GameState.PLAYING

func Start_Wave() -> void:
	$UI/HUD/High.visible = false
	$UI/HUD/GameOver.visible = false
	
	enemies_to_spawn_this_wave = current_wave * max_spawn
	Update_UI()

func Update_UI() -> void:
	current_goblins = get_tree().get_nodes_in_group("enemies").size()
	$UI/HUD/PlayerUi/EnemyCount.text = " X " + str(current_goblins)
	$UI/HUD/PlayerUi/WaveCount.text = "WAVE: " + str(current_wave)
	$UI/HUD/PlayerUi/LifeCount.text = " X " + str(current_lives)

func _ready() -> void:
	$Bush.add_to_group("wall")

	current_wave = 1
	current_lives = lives

	Start_Wave()

func _process(delta: float) -> void:
	pass

func _on_player_dead() -> void:
	game_state = GameState.GAME_OVER
	if current_wave > Autoload.highest_wave:
		Autoload.highest_wave = current_wave
		$UI/HUD/High/Panel/HighWaveLabel.text = "HIGHEST WAVE:\n" + str(Autoload.highest_wave)
		$UI/HUD/High.visible = true

	$UI/HUD/GameOver.visible = true
	get_tree().paused = true


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
		$WaveCD2.start()
		await $WaveCD2.timeout
		Start_Wave()


func _on_wave_cd_timeout() -> void:
	$UI/HUD/NextWave.visible = false
