extends CharacterBody2D

var screen_size : Vector2

@export var speed : int = 250

func get_input() -> void:
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir.normalized() * speed

func _ready() -> void:
	screen_size = get_viewport_rect().size
	position = screen_size / 2

func _physics_process(delta: float) -> void:
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
