extends CharacterBody2D

signal i_died
signal i_was_here

enum GoblinTypes { BASE_GOBLIN, CHARGER_GOBLIN }
enum GoblinState { ENTERING, IDLE_WAIT, CHASING, CHARGING, DEAD }

@export var goblin_type: GoblinTypes = GoblinTypes.BASE_GOBLIN
@export var droptable : DropTable
@export var charge_cooldown_time: float = 3.0 # Adjustable cooldown duration

@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("Player") 
@onready var state : GoblinState = GoblinState.ENTERING

@onready var nav_agent: NavigationAgent2D = $Nav2d
@onready var raycast: RayCast2D = $RayCast2D
@onready var stats: StatComponent = $StatComponent
@onready var hitbox_area: Area2D = $HitboxArea
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox_shape: CollisionShape2D = %HitboxShape

@onready var attack_cd: Timer = $AttackCD
@onready var move_toward_timer: Timer = $MoveTowardTimer
@onready var timer_to_idle: Timer = $TimerToIdle
@onready var removal: Timer = $Removal

var direction : Vector2
var distance : float
var next_path_pos : Vector2
var charge_direction : Vector2 = Vector2.ZERO
var is_charge_on_cooldown: bool = false

func _ready() -> void:
	add_to_group("enemies")
	setup_goblin_stats()
	
	stats.you_died.connect(dead)

func setup_goblin_stats() -> void:
	if goblin_type == GoblinTypes.CHARGER_GOBLIN:
		stats.initialize_stats(4.0, randf_range(80.0, 90.0), 2.0)
		animated_sprite_2d.self_modulate = Color.html("646464")
		attack_cd.wait_time = charge_cooldown_time
	else:
		stats.initialize_stats(2.0, randf_range(90.0, 150.0), 1.0)
		raycast.enabled = false

# GOBLIN STATE MACHINE
func _physics_process(_delta: float) -> void:
	var temp_dir : Vector2 = (player.global_position - global_position)
	distance = temp_dir.length()
	if state == GoblinState.DEAD:
		return
		
	match state:
		GoblinState.ENTERING:
			initial_entry()

		GoblinState.IDLE_WAIT:
			animated_sprite_2d.play("idle")
			velocity = Vector2.ZERO
			if goblin_type == GoblinTypes.CHARGER_GOBLIN:
				check_target()

		GoblinState.CHASING:
			move_to_target()
			if goblin_type == GoblinTypes.CHARGER_GOBLIN:
				check_target()
				
		GoblinState.CHARGING:
			execute_charge()


func initial_entry() -> void:
	if !is_instance_valid(player):
		return
		
	animated_sprite_2d.play("walk")
	var entry_speed: float = 80.0
	var dist = get_viewport_rect().get_center() - position
	velocity = dist.normalized() * entry_speed
	flip()
	move_and_slide()


func move_to_target() -> void:
	if !is_instance_valid(player):
		return
		
	animated_sprite_2d.play("run")
	
	nav_agent.target_position = player.global_position
	
	if nav_agent.is_navigation_finished():
		if (distance <= hitbox_shape.shape.size.length() and 
			state != GoblinState.DEAD
		):
			animation_player.play("attack")
		return
		
	next_path_pos = nav_agent.get_next_path_position()
	direction = (next_path_pos - global_position).normalized()
	velocity = direction * stats.movement_speed

	flip()
	move_and_slide()

# Charger detection mechanics
func check_target() -> void:
	if !is_instance_valid(player) or is_charge_on_cooldown:
		return

	raycast.target_position = to_local(player.global_position)
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider == player:
			charge_direction = (player.global_position - global_position).normalized()
			state = GoblinState.CHARGING
			animated_sprite_2d.play("run")

# Charger-specific charging movement loop
func execute_charge() -> void:
	var charge_speed: float = 350.0
	velocity = charge_direction * charge_speed
	flip()

	var collided = move_and_slide()

	if collided:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()

			if collider == player and collider.has_method("took_a_hit"):
				collider.took_a_hit(stats.damage)

			# Start cooldown process immediately after impact
			is_charge_on_cooldown = true
			attack_cd.start()

			state = GoblinState.CHASING
			break

func flip() -> void:
	if velocity.x != 0:
		if velocity.x < -0.1:
			$AnimatedSprite2D.flip_h = true
		elif velocity.x > 0.1:
			$AnimatedSprite2D.flip_h = false

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if state == GoblinState.ENTERING:
		timer_to_idle.start()

func _on_screen_notif_screen_exited() -> void:
	state = GoblinState.CHASING

func _on_hitbox_area_body_entered(body: CharacterBody2D) -> void:
	print("fk u")
	if state == GoblinState.DEAD:
		return
	if body.has_method("took_a_hit"):
		var current_damage = 1.0 if (goblin_type == GoblinTypes.CHARGER_GOBLIN and is_charge_on_cooldown) else stats.damage
		body.took_a_hit(current_damage)

func _on_timer_to_idle_timeout() -> void:
	state = GoblinState.IDLE_WAIT
	animated_sprite_2d.play("idle")
	move_toward_timer.start()

func _on_move_toward_timer_timeout() -> void:
	if state != GoblinState.CHARGING:
		state = GoblinState.CHASING

func _on_attack_cd_timeout() -> void:
	is_charge_on_cooldown = false

func dead() -> void:
	state = GoblinState.DEAD
	velocity = Vector2.ZERO
	timer_to_idle.stop()
	move_toward_timer.stop()
	attack_cd.stop()

	i_died.emit()
	i_was_here.emit(global_position, droptable.drop_loot_rng())
	remove_from_group("enemies")
	animated_sprite_2d.play("dead")
	removal.start()
	collision_layer = 0
	collision_mask = 0

func _on_removal_timeout() -> void:
	queue_free()
