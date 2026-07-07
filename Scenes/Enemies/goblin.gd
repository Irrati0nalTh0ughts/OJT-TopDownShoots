extends CharacterBody2D

signal i_died

var player : CharacterBody2D

var entered_screen : bool
var speed : int = 100
var direction : Vector2

var alive : bool = true

#connected to bullet
func dead() -> void:
	emit_signal("i_died")
	alive = false
	$AnimatedSprite2D.play("dead")
	remove_from_group("enemies")
	$Removal.start()
	collision_layer = 0
	speed = 0

func _ready() -> void:
	add_to_group("enemies")
	player = get_tree().get_first_node_in_group("Player")
	$AnimatedSprite2D.play("run")
	var screen_rect = get_viewport_rect()
	
	var dist = screen_rect.get_center() - position
	
	if abs(dist.x) > abs(dist.y):
		direction.x = dist.x
		direction.y = 0
	else:
		direction.y = dist.y
		direction.x = 0

func _physics_process(_delta: float) -> void:
	direction = direction.normalized()
	velocity = direction * speed
	

	if direction.x != 0:
		if direction.x == -1:
			$AnimatedSprite2D.flip_h = true
		elif direction.x == 1:
			$AnimatedSprite2D.flip_h = false
	
	if $Timer.is_stopped() == true:
		if player == null:
			return

		var dir : Vector2 = (player.global_position - global_position).normalized()
		velocity = dir * speed

	move_and_slide()

func _on_timer_timeout() -> void:
	speed += 25


func _on_area_2d_body_entered(_body: Node2D) -> void:
	if !alive:
		return

	if _body.is_in_group("Player"):
		_body.take_hit()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$Timer.start()


func _on_removal_timeout() -> void:
	queue_free()
