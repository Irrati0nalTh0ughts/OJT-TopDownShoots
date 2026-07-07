extends CharacterBody2D

@export var bullet_scene : PackedScene

signal i_got_hit(dmg: int)

var screen_size : Vector2

@export var speed : int = 250

func took_a_hit(damage: int) -> void:
	i_got_hit.emit(damage)
	print("player got hit")

func get_input() -> void:
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir.normalized() * speed

func fire() -> void:
	if !$FireCD.is_stopped():
		return

	var bullet = bullet_scene.instantiate()
	if Input.is_action_just_pressed("lmb"):
		bullet.position = global_position
		bullet.direction = (get_global_mouse_position() - global_position).normalized()
		print("Fired...")
		$FireCD.start()
		get_tree().current_scene.add_child(bullet)

func _ready() -> void:
	add_to_group("Player")
	screen_size = get_viewport_rect().size
	position = screen_size / 2

func _physics_process(_delta: float) -> void:
	fire()
	get_input()
	move_and_slide()
	
	position = position.clamp(Vector2.ZERO, screen_size)
	
	var mouse = get_local_mouse_position()
	
	if mouse != Vector2.ZERO:
		var angle = snappedf(mouse.angle(),PI / 4) / (PI / 4)
		angle = wrap(int(angle), 0, 8)
		
		$AnimatedSprite2D.animation = "walk" + str(angle)
	
	if velocity.length() != 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 1
