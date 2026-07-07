extends Node2D

signal a_goblin_died

var goblin_scene : PackedScene = preload("res://Scenes/Enemies/goblin.tscn")

var spawnpoint : Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		if i is Marker2D:
			spawnpoint.append(i)

func _on_timer_timeout() -> void:
	if get_parent().enemies_spawned_this_wave == get_parent().enemies_to_spawn_this_wave:
		return

	var spawn = spawnpoint[randi() % spawnpoint.size()]
	var goblin = goblin_scene.instantiate()
	goblin.position = spawn.position
	goblin.i_died.connect(_on_goblin_death)
	get_tree().current_scene.add_child(goblin)
	get_parent().enemies_spawned_this_wave += 1
	get_parent().Update_UI()
		
func _on_goblin_death() -> void:
	emit_signal("a_goblin_died")
	print("g_died")
