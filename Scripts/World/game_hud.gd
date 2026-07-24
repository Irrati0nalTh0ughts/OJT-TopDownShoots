extends Control

signal start_game_requested
signal return_to_main_menu_requested

@onready var menu_control: Control = %MAINMENU_UI
@onready var pause_control: Control = %PAUSED_UI
@onready var settings_ui: Control = %SETTINGS_UI
@onready var hud: UI_HUD = %HUD

enum MenuState {
	MAIN_MENU,
	PLAYING,
	PAUSED,
	SETTINGS,
}

var state: MenuState = MenuState.MAIN_MENU
var previous_menu: MenuState
var settings_return_state: MenuState = MenuState.MAIN_MENU


func _ready() -> void:
	# Menu must keep receiving input even while gameplay is paused.
	process_mode = Node.PROCESS_MODE_ALWAYS
	_apply_state(state)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_cancel"):
		return

	match state:
		MenuState.PLAYING:
			set_state(MenuState.PAUSED)
		MenuState.PAUSED:
			set_state(MenuState.PLAYING)
		MenuState.SETTINGS:
			close_settings()
		MenuState.MAIN_MENU:
			pass


func set_state(new_state: MenuState) -> void:
	if state == new_state:
		return

	previous_menu = state
	state = new_state
	_apply_state(new_state)


func _apply_state(current_state: MenuState) -> void:
	menu_control.visible = false
	pause_control.visible = false
	settings_ui.visible = false
	hud.visible = false

	match current_state:
		MenuState.MAIN_MENU:
			menu_control.visible = true
			get_tree().paused = true

		MenuState.PLAYING:
			hud.visible = true
			get_tree().paused = false

		MenuState.PAUSED:
			pause_control.visible = true
			get_tree().paused = true

		MenuState.SETTINGS:
			settings_ui.visible = true


func open_settings() -> void:
	settings_return_state = state
	set_state(MenuState.SETTINGS)


func close_settings() -> void:
	set_state(settings_return_state)


# --- Main Menu buttons ---

func _on_mainmenu_ui_start_game_mbttn() -> void:
	set_state(MenuState.PLAYING)
	start_game_requested.emit()


func _on_mainmenu_ui_player_options_mbttn() -> void:
	open_settings()


func _on_mainmenu_ui_quit_game_mbttn() -> void:
	get_tree().quit()

# --- Pause buttons ---

func _on_paused_ui_resume_game_pbttn() -> void:
	set_state(MenuState.PLAYING)


func _on_paused_ui_player_options_pbttn() -> void:
	open_settings()


func _on_paused_ui_mainmenu_pbttn() -> void:
	return_to_main_menu_requested.emit()

# --- Settings buttons ---

func _on_settings_ui_settings_back_bttn() -> void:
	close_settings()
