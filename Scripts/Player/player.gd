extends CharacterBody2D

signal current_ammo_changed(ammo: int)
signal health_changed(current_health: float, max_health: float)
signal i_died

@export var bullet_scene : PackedScene
@export var respawn_delay: float = 1.0

@onready var stats: StatComponent = $StatsComponent
@onready var buff_component: BuffComponent = $BuffComponent

@onready var state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var fire_cd: Timer = $FireCD
@onready var player: CharacterBody2D = $"."

var current_ammo: int = 15
var base_speed: float = 250.0
var screen_size : Vector2


func _ready() -> void:
	add_to_group("Player")
	screen_size = get_viewport_rect().size
	position = screen_size / 2

	stats.initialize_stats(10.0, base_speed, 1.0)
	current_ammo_changed.emit(current_ammo)
	health_changed.emit(stats.current_health, stats.max_health)


func took_a_hit(damage: int) -> void:
	if state_machine.current_state == PlayerStateMachine.State.DEAD:
		return

	stats.took_damage(damage)

	if state_machine.current_state != PlayerStateMachine.State.DEAD:
		state_machine.SetState(PlayerStateMachine.State.HURT)


func spawn_bullet(direction: Vector2) -> void:
	var bullet = bullet_scene.instantiate()

	bullet.global_position = global_position
	bullet.direction = direction
	bullet.rotation = direction.angle()

	get_parent().add_child(bullet)


func fire() -> void:
	if !$FireCD.is_stopped() or current_ammo <= 0:
		return
	var base_direction = (get_global_mouse_position() - global_position).normalized()

	if buff_component.special_gun_buff_active:
		if Input.is_action_pressed("lmb"):
			fire_cd.start()
			spawn_bullet(base_direction)
			spawn_bullet(base_direction.rotated(-PI / 4))
			spawn_bullet(base_direction.rotated(PI / 4))
	else:
		if Input.is_action_just_pressed("lmb"):
			spawn_bullet(base_direction)

			$FireCD.start()
			current_ammo -= 1
			current_ammo_changed.emit(current_ammo)


func _physics_process(_delta: float) -> void:
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir.normalized() * stats.movement_speed
	
	state_machine.UpdateState(_delta)
	if state_machine.can_take_input():
		move_and_slide()
		position = position.clamp(Vector2.ZERO, screen_size)

	update_facing_animation()


func update_facing_animation() -> void:
	var mouse = get_local_mouse_position()

	# PLAYER 8 FACING ANGLE CALCULATION
	if mouse != Vector2.ZERO:
		var angle = snappedf(mouse.angle(), PI / 4) / (PI / 4)
		angle = wrap(int(angle), 0, 8)
		# Works since sprite naming pattern is based on the angle output
		animated_sprite_2d.animation = "walk" + str(angle)

	if velocity.length() != 0:
		animated_sprite_2d.play()
	else:
		animated_sprite_2d.stop()
		animated_sprite_2d.frame = 1


func _on_stats_component_health_changed(current_health: float, max_health: float) -> void:
	health_changed.emit(current_health, max_health)


func _on_stats_component_you_died() -> void:
	i_died.emit()


func _on_fire_cd_timeout() -> void:
	pass # Replace with function body.
