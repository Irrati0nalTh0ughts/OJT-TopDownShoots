extends Node

#Game starts
#→ SettingsManager loads config file
#→ Loaded values replace defaults
#→ SettingsManager applies loaded values
#→ Menu reads SettingsManager values
#→ UI controls display those values

const SETTINGS_PATH := "user://settings.cfg"

var current_window_mode: int = DisplayServer.WINDOW_MODE_WINDOWED
var current_resolution: Vector2i = Vector2i(1280, 720)
var current_fps_limit: int = 60
var current_vsync_mode: int = DisplayServer.VSYNC_ENABLED

var current_master_volume: float = 1.0
var current_music_volume: float = 1.0
var current_sfx_volume: float = 1.0
	
const FPS_PRESETS: Array[int] = [
	30,
	60,
	0 # Unlimited
]

const BASE_RESOLUTIONS: Array[Vector2i] = [
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080)
]

const WINDOW_MODES = {
	"Windowed": DisplayServer.WINDOW_MODE_WINDOWED,
	"Fullscreen": DisplayServer.WINDOW_MODE_FULLSCREEN,
	"Exclusive": DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
}


func get_window_type() -> Dictionary:
	return WINDOW_MODES


func get_native_resolution() -> Vector2i:
	var screen_id := DisplayServer.window_get_current_screen()
	return DisplayServer.screen_get_size(screen_id)


func get_resolution_options() -> Array[Vector2i]:
	var native_resolution : Vector2i = get_native_resolution()
	var options: Array[Vector2i] = []

	# Native resolution is always first.
	options.append(native_resolution)

	for resolution in BASE_RESOLUTIONS:
		# Don't offer resolutions larger than the monitor.
		if resolution.x <= native_resolution.x \
		and resolution.y <= native_resolution.y \
		and resolution != native_resolution:
			options.append(resolution)

	return options


func apply_display_settings(
	window_mode: int,
	resolution: Vector2i
) -> void:
	current_window_mode = window_mode
	current_resolution = resolution

	DisplayServer.window_set_mode(current_window_mode)
	DisplayServer.window_set_size(current_resolution)

func apply_master_volume(value: float) -> void:
	current_master_volume = value
	set_bus_volume("Master", current_master_volume)


func apply_music_volume(value: float) -> void:
	current_music_volume = value
	set_bus_volume("Music", current_music_volume)


func apply_sfx_volume(value: float) -> void:
	current_sfx_volume = value
	set_bus_volume("SFX", current_sfx_volume)

func apply_fps_limit(fps_limit: int) -> void:
	current_fps_limit = fps_limit
	Engine.max_fps = current_fps_limit


func apply_vsync_mode(vsync_mode: int) -> void:
	current_vsync_mode = vsync_mode
	DisplayServer.window_set_vsync_mode(current_vsync_mode)


func center_window() -> void:
	var screen_id : int = DisplayServer.window_get_current_screen()
	var screen_position : Vector2i = DisplayServer.screen_get_position(screen_id)
	var screen_size : Vector2i = DisplayServer.screen_get_size(screen_id)
	var window_size : Vector2i = DisplayServer.window_get_size()

	var centered_position := (
		screen_position
		+ (screen_size - window_size) / 2
	)

	DisplayServer.window_set_position(centered_position)


func save_settings() -> void:
	var config : ConfigFile = ConfigFile.new()
	
	# Display config creation
	config.set_value(
		"display", 
		"window_mode", 
		DisplayServer.window_get_mode()
	)
	config.set_value(
		"display", 
		"resolution", 
		DisplayServer.window_get_size()
	)
	config.set_value(
		"display", 
		"fps_limit", 
		Engine.max_fps
	)
	config.set_value(
		"display",
		"vsync",
		DisplayServer.window_get_vsync_mode()
	)
	
	# Audio config creation
	config.set_value("audio", "master", get_bus_volume("Master"))
	config.set_value("audio", "music", get_bus_volume("Music"))
	config.set_value("audio", "sfx", get_bus_volume("SFX"))

	var error := config.save(SETTINGS_PATH)

	if error != OK:
		push_error("Failed to save settings: %s" % error_string(error))


func get_bus_volume(bus_name: String) -> float:
	var bus_index := AudioServer.get_bus_index(bus_name)

	if bus_index == -1:
		push_error("Audio bus not found: %s" % bus_name)
		return 1.0

	var volume_db := AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func set_bus_volume(bus_name: StringName, linear_value: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)

	if bus_index == -1:
		push_error("Audio bus not found: %s" % bus_name)
		return

	if linear_value <= 0.0:
		AudioServer.set_bus_volume_db(bus_index, -80.0)
	else:
		AudioServer.set_bus_volume_db(
			bus_index,
			linear_to_db(linear_value)
		)


func load_settings() -> void:
	var config := ConfigFile.new()
	var error := config.load(SETTINGS_PATH)

	if error != OK:
		print("No valid settings file found. Using defaults.")
		return

	current_window_mode = config.get_value(
		"display",
		"window_mode",
		DisplayServer.WINDOW_MODE_WINDOWED
	)
	current_resolution = config.get_value(
		"display",
		"resolution",
		Vector2i(1280, 720)
	)
	current_fps_limit = config.get_value(
		"display",
		"fps_limit",
		60
	)
	current_vsync_mode = config.get_value(
		"display",
		"vsync",
		DisplayServer.VSYNC_ENABLED
	)


	current_master_volume = config.get_value(
		"audio",
		"master",
		1.0
	)
	current_music_volume = config.get_value(
		"audio",
		"music",
		1.0
	)
	current_sfx_volume = config.get_value(
		"audio",
		"sfx",
		1.0
	)

func apply_all_settings() -> void:
	apply_display_settings(
		current_window_mode,
		current_resolution
	)

	apply_fps_limit(current_fps_limit)
	apply_vsync_mode(current_vsync_mode)

	apply_master_volume(current_master_volume)
	apply_music_volume(current_music_volume)
	apply_sfx_volume(current_sfx_volume)
	center_window()
