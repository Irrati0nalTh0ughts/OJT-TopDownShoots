extends Control

class_name UI_HUD

signal _restart_bttn
signal _hc_restart_bttn

@onready var player_ui: Panel = %PlayerUi

@onready var wave_count: Label = %WaveCount
@onready var life_count: Label = %LifeCount
@onready var ammo_count: Label = %AmmoCount
@onready var enemy_count: Label = %EnemyCount

@onready var game_over: Panel = %GameOver
@onready var game_over_panel: Panel = %GameOverPanel
@onready var wave_label: Label = %WaveLabel
@onready var restart_bttn: Button = %RestartBttn
@onready var high_wave_label: Label = %HighWaveLabel

@onready var high_cont: Panel = %HighCont
@onready var hc_high_panel: Panel = %HCHighPanel
@onready var hc_wave_label: Label = %HCWaveLabel
@onready var hc_restart_bttn: Button = %HCRestartBttn
@onready var hc_high_wave_label: Label = %HCHighWaveLabel

@onready var next_wave: Panel = %NextWave
@onready var next_wave_label: Label = %NextWaveLabel


func _on_restart_bttn_pressed() -> void:
	_restart_bttn.emit()


func _on_hc_restart_bttn_pressed() -> void:
	_hc_restart_bttn.emit()
