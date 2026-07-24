extends Node2D

signal a_goblin_died
signal a_goblin_was_there

@export var spawn_table : DropTable 

var goblin_scene : PackedScene = preload("res://Scenes/Enemies/goblin.tscn")
var spawnpoint : Array = []

func _ready() -> void:
	for i in get_children():
		if i is Marker2D:
			spawnpoint.append(i)

func _on_timer_timeout() -> void:
	if get_parent().enemies_spawned_this_wave == get_parent().enemies_to_spawn_this_wave:
		return

	if not spawn_table:
		return

	var rolled_entry = spawn_table.drop_mob_rng() 

	if rolled_entry == null:
		return

	var spawn = spawnpoint[randi() % spawnpoint.size()]
	var goblin = goblin_scene.instantiate()
	
	match rolled_entry.goblin_type:
		0:
			goblin.goblin_type = goblin.GoblinTypes.BASE_GOBLIN
		1:
			goblin.goblin_type = goblin.GoblinTypes.CHARGER_GOBLIN

	goblin.position = spawn.position
	goblin.i_died.connect(_on_goblin_death)
	goblin.i_was_here.connect(_a_goblin_was_there)
	get_tree().current_scene.add_child(goblin)
	
	get_parent().enemies_spawned_this_wave += 1
	get_parent().Update_UI()

func _on_goblin_death() -> void:
	emit_signal("a_goblin_died")

func _a_goblin_was_there(gob_finalpos: Vector2, itemref: CollectibleData) -> void:
	if itemref == null:
		return
	print_debug(itemref)
	a_goblin_was_there.emit(gob_finalpos, itemref)
