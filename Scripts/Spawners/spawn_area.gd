extends Node2D

signal a_goblin_died
signal a_goblin_was_there

var goblin_scene : PackedScene = preload("res://Scenes/Enemies/goblin.tscn")

var spawnpoint : Array = []

func _ready() -> void:
	# Will go through every child "Marker2" and adds it in spawnpoint Array ONCE!
	# Basically saying these are the places you can spawn into
	for i in get_children():
		if i is Marker2D:
			spawnpoint.append(i)


func _on_timer_timeout() -> void:
	# Check is so that summons won't go over specified amount. Works because this scene is a Direct child of World/Main.tscn
	if get_parent().enemies_spawned_this_wave == get_parent().enemies_to_spawn_this_wave:
		return

	var spawn = spawnpoint[randi() % spawnpoint.size()]
	var goblin = goblin_scene.instantiate()
	
	goblin.position = spawn.position
	goblin.i_died.connect(_on_goblin_death)
	goblin.i_was_here.connect(_a_goblin_was_there)
	get_tree().current_scene.add_child(goblin) # Works because this Scene is AT the scene where it should be spawning Goblins
	get_parent().enemies_spawned_this_wave += 1
	get_parent().Update_UI()

func _on_goblin_death() -> void:
	emit_signal("a_goblin_died")

# Emits to listeners, specifically to "Collectible Spawner"
func _a_goblin_was_there(gob_finalpos: Vector2, itemref: CollectibleData) -> void:
	a_goblin_was_there.emit(gob_finalpos, itemref)
	
	# Debug if it is actually going through
	#print("Goblin Final Position: [ ", gob_finalpos, " ] | CollectibleData Ref.: [ ", itemref, " ]")


# Learned that you can put value or call a variable or method from your DIRECT PARENT with "get_parent()"
