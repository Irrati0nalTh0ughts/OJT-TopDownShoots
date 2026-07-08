extends CharacterBody2D

signal i_got_hit(dmg: int)

@export var bullet_scene : PackedScene

var base_speed: int = 250
var speed_bonus: int = 0

var speed: int:
	get:
		return base_speed + speed_bonus

var gun_buff_active: bool = false
var screen_size : Vector2

func took_a_hit(damage: int) -> void:
	i_got_hit.emit(damage)
	print("player got hit")

func get_input() -> void:
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir.normalized() * speed

func fire() -> void:
	if !$FireCD.is_stopped():
		return
	
	if Input.is_action_pressed("lmb"):
		var base_direction = (get_global_mouse_position() - global_position).normalized()
		
		if gun_buff_active:
			spawn_bullet(base_direction)
			spawn_bullet(base_direction.rotated(-PI / 4))
			spawn_bullet(base_direction.rotated(PI / 4))
		else:
			spawn_bullet(base_direction)
		
		$FireCD.start()

func apply_coffee_buff(effect_amount: int, effect_duration: float) -> void:
	speed_bonus = effect_amount
	
	$Coffee_Duration.wait_time = effect_duration
	$Coffee_Duration.start()

func apply_gun_buff(_effect_amount: int, effect_duration: float) -> void:
	gun_buff_active = true

	$Gun_Duration.wait_time = effect_duration
	$Gun_Duration.start()

func spawn_bullet(direction: Vector2) -> void:
	var bullet = bullet_scene.instantiate()
	
	bullet.global_position = global_position
	bullet.direction = direction
	bullet.rotation = direction.angle()
	
	get_parent().add_child(bullet)

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


func _on_gun_duration_timeout() -> void:
	gun_buff_active = false


func _on_coffee_duration_timeout() -> void:
	speed_bonus = 0
