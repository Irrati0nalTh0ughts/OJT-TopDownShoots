extends Area2D

@export var bullet_spd : int = 400

var direction : Vector2 = Vector2.ZERO
var did_hit : bool = false


func _process(delta: float) -> void:
	position += direction * bullet_spd * delta


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("dead"):
		#print("BODY HIT: ", body.name, " ", body.get_groups())
		did_hit = true
		body.dead()
		await get_tree().process_frame
		queue_free()
	elif body.is_in_group("wall"):
		queue_free()


func _on_air_time_timeout() -> void:
	queue_free()
