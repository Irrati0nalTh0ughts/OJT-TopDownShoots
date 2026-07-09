extends CharacterBody2D

signal i_died
signal i_was_here

enum GoblinState { ENTERING, IDLE_WAIT, CHASING, DEAD }

# Meaning the first class/scene inside that Group. IMO Good for use only when there is only 1 Node inside.
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("Player") 
@onready var state : GoblinState = GoblinState.ENTERING

# Referenced DropTable so that I can get the output of the function inside it DropRNG()
@export var droptable : DropTable

var damage : int = 1
var speed : int

var direction : Vector2

# Connected to Bullet.tscn VIA has_method("dead") for check and assuming it checks, you can call "body.dead()"
func dead() -> void:
	if state == GoblinState.DEAD:
		return

	state = GoblinState.DEAD
	velocity = Vector2.ZERO
	$TimerToIdle.stop()
	$MoveTowardTimer.stop()

	i_died.emit()
	# Emits its final position and RNG output to listeners
	i_was_here.emit(global_position, droptable.DropRNG())
	# Removes itself from group so counter doesn't count dead goblins as well
	remove_from_group("enemies")
	$AnimatedSprite2D.play("dead")
	$Removal.start()
	collision_layer = 0
	collision_mask = 0

# Moves into player screen rect after Spawn
func initial_entry() -> void:
	# Won't move to center if TimerToIdle is working, Player is nonexistent and Goblin not alive
	if !is_instance_valid(player) and state == GoblinState.DEAD:
		return
	else:
		$AnimatedSprite2D.play("walk")

		speed = 80
		var dist = get_viewport_rect().get_center() - position
		velocity = dist.normalized() * speed
		flip()
		move_and_slide()

# Moves after Idle, in acting a goblin seeing the player
func move_to_target() -> void:
	if !is_instance_valid(player):
		return
	$AnimatedSprite2D.play("run")

	speed = 150
	direction = (player.global_position - global_position).normalized()
	velocity = direction * speed

	flip()
	move_and_slide()

# Flips Sprite
func flip() -> void:
	if velocity.x != 0:
		if velocity.x < -0.1:
			$AnimatedSprite2D.flip_h = true
		elif velocity.x > 0.1:
			$AnimatedSprite2D.flip_h = false

func _ready() -> void:
	add_to_group("enemies")

# GOBLIN STATE MACHINE
func _physics_process(_delta: float) -> void:
	if state == GoblinState.DEAD:
		return
	match state:
		GoblinState.ENTERING:
			initial_entry()

		GoblinState.IDLE_WAIT:
			$AnimatedSprite2D.play("idle")

		GoblinState.CHASING:
			move_to_target()


func _on_player_area_body_entered(_body: Node2D) -> void:
	if state == GoblinState.DEAD:
		return

	if _body.has_method("took_a_hit"):
		_body.took_a_hit(damage)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if state == GoblinState.ENTERING:
		$TimerToIdle.start()


# Start when Goblin is seen within Screen Rect
func _on_timer_to_idle_timeout() -> void:
	state = GoblinState.IDLE_WAIT
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("idle")
	$MoveTowardTimer.start()
	#print("arrived...")


# After IdleTimer
func _on_move_toward_timer_timeout() -> void:
	state = GoblinState.CHASING
	#print("old spawn")


# Erases goblin in scene tree after Timeout
func _on_removal_timeout() -> void:
	queue_free()
