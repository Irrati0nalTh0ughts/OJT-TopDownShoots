extends Control

signal resume_game_Pbttn
signal player_options_Pbttn
signal mainmenu_Pbttn
#signal back_Pbttn

func _on_p_rsm_pressed() -> void:
	resume_game_Pbttn.emit()


func _on_p_sttngs_pressed() -> void:
	player_options_Pbttn.emit()


func _on_p_main_m_pressed() -> void:
	mainmenu_Pbttn.emit()


#func _on_pb_2g_pressed() -> void:
	#back_Pbttn.emit()
