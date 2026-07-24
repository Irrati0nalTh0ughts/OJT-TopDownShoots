extends Control

signal settings_back_bttn

var resolution_options: Array[Vector2i] = []
var fps_options: Array[int] = []

var selected_window_type : int
var selected_resolution : Vector2i
var selected_fps : int

func _ready() -> void:
	SettingsManager.load_settings()
	SettingsManager.apply_all_settings()


	setup_window_options()
	setup_resolution_options()
	setup_fps_options()
	setup_audio_options()
	setup_vsync_option()

func setup_window_options() -> void:
	var window_modes : Dictionary = SettingsManager.get_window_type()

	for label in window_modes:
		var mode: int = window_modes[label]

		%WindowType.add_item(label)

		var item_index : int = %WindowType.item_count - 1
		%WindowType.set_item_metadata(item_index, mode)
	
	for index in range(%WindowType.item_count):
		var mode: int = %WindowType.get_item_metadata(index)

		if mode == SettingsManager.current_window_mode:
			%WindowType.select(index)
			selected_window_type = mode
			break

func setup_resolution_options() -> void:
	resolution_options = SettingsManager.get_resolution_options()
	var native_resolution : Vector2i = SettingsManager.get_native_resolution()

	for resolution in resolution_options:
		var label : String = "%d × %d" % [resolution.x, resolution.y]

		if resolution == native_resolution:
			label = "Native (%d × %d)" % [
				resolution.x,
				resolution.y
			]

		%ResType.add_item(label)
	
	for index in range(resolution_options.size()):
		if resolution_options[index] == SettingsManager.current_resolution:
			%ResType.select(index)
			selected_resolution = resolution_options[index]
			break
	
	if selected_resolution == Vector2i.ZERO:
		selected_resolution = resolution_options[0]
		%ResType.select(0)

func setup_fps_options() -> void:
	fps_options = SettingsManager.FPS_PRESETS.duplicate()

	for fps in fps_options:
		if fps == 0:
			%FPSType.add_item("Unlimited")
		else:
			%FPSType.add_item("%d FPS" % fps)
	
	for index in range(fps_options.size()):
		if fps_options[index] == SettingsManager.current_fps_limit:
			%FPSType.select(index)
			selected_fps = fps_options[index]
			break

func setup_audio_options() -> void:
	%MasterSlider.value = SettingsManager.current_master_volume * 100
	%MusicSlider.value = SettingsManager.current_music_volume * 100
	%SFXSlider.value = SettingsManager.current_sfx_volume * 100

func setup_vsync_option() -> void:
	%VSyncCB.button_pressed = (
		SettingsManager.current_vsync_mode == DisplayServer.VSYNC_ENABLED
	)


func _on_window_type_item_selected(index: int) -> void:
	selected_window_type = %WindowType.get_item_metadata(index)
	print("win selected")


func _on_res_type_item_selected(index: int) -> void:
	selected_resolution = resolution_options[index]
	print("res selected")


func _on_fps_type_item_selected(index: int) -> void:
	selected_fps = fps_options[index]
	print("fps selected")


func _on_v_sync_cb_toggled(toggled_on: bool) -> void:
	var mode := (
		DisplayServer.VSYNC_ENABLED
		if toggled_on
		else DisplayServer.VSYNC_DISABLED
	)
	
	SettingsManager.apply_vsync_mode(mode)


func _on_sfx_slider_value_changed(value: float) -> void:
	SettingsManager.apply_sfx_volume(value / 100)
	print(value)


func _on_music_slider_value_changed(value: float) -> void:
	SettingsManager.apply_music_volume(value / 100)
	print(value)


func _on_master_slider_value_changed(value: float) -> void:
	SettingsManager.apply_master_volume(value / 100)
	print(value)


func _on_sttngs_apply_bttn_pressed() -> void:
	print("Window mode: ", selected_window_type)
	print("Resolution: ", selected_resolution)
	print("FPS: ", selected_fps)
	SettingsManager.apply_display_settings(
		selected_window_type,
		selected_resolution
	)

	SettingsManager.apply_fps_limit(selected_fps)
	SettingsManager.center_window()
	SettingsManager.save_settings()
	print("Settings Applied")


func _on_sttngs_bck_bttn_pressed() -> void:
	settings_back_bttn.emit()
