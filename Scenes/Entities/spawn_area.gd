extends Node2D

@onready var world: Node2D = get_node("/root/World")
var goblin_scene := preload("res://Scenes/Enemies/goblin.tscn")

var spawnpoint : Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		if i is Marker2D:
			spawnpoint.append(i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var spawn = spawnpoint[randi() % spawnpoint.size()]
	var goblin = goblin_scene.instantiate()
	goblin.position = spawn.position
	world.add_child(goblin)
