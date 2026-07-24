extends Control

signal start_game_Mbttn
signal quit_game_Mbttn
signal player_options_Mbttn

func _ready() -> void:
	pass


func _on_start_pressed() -> void:
	start_game_Mbttn.emit()


func _on_quit_pressed() -> void:
	quit_game_Mbttn.emit()


func _on_settings_pressed() -> void:
	player_options_Mbttn.emit()
