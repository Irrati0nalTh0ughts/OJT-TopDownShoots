extends Node

class_name PlayerStateMachine

signal state_changed(old_state: State, new_state: State)

enum State { IDLE, MOVE, HURT, DEAD }

@export var hurt_duration: float = 0.3

var current_state: State = State.IDLE

@onready var player: CharacterBody2D = $".."



func _ready() -> void:
	await  get_tree().process_frame
	EnterState(current_state)

# --- Core FSM contract ---

func SetState(new_state: State) -> void:
	if new_state == current_state:
		return

	ExitState(current_state)
	var old_state := current_state
	current_state = new_state
	EnterState(current_state)

	state_changed.emit(old_state, current_state)


func EnterState(state: State) -> void:
	match state:
		State.IDLE:
			player.velocity = Vector2.ZERO
			player.animated_sprite_2d.stop()
			player.animated_sprite_2d.frame = 1

		State.MOVE:
			player.animated_sprite_2d.play()

		State.HURT:
			player.velocity = Vector2.ZERO
			get_tree().create_timer(hurt_duration).timeout.connect(_on_hurt_timeout, CONNECT_ONE_SHOT)

		State.DEAD:
			player.velocity = Vector2.ZERO
			player.collision_layer = 0
			player.collision_mask = 0
			player.animated_sprite_2d.play("dead")


func ExitState(state: State) -> void:
	match state:
		State.DEAD:
			player.collision_layer = player.default_collision_layer
			player.collision_mask = player.default_collision_mask
		_:
			pass


func UpdateState(_delta: float) -> void:
	match current_state:
		State.IDLE, State.MOVE:
			player.fire()
			SetState(State.MOVE if player.velocity.length() > 0.0 else State.IDLE)

		State.HURT:
			pass # locked out of input/movement while flinching

		State.DEAD:
			pass # locked out permanently until the scene restarts


func can_take_input() -> bool:
	return current_state == State.IDLE or current_state == State.MOVE


func _on_hurt_timeout() -> void:
	if current_state == State.HURT:
		SetState(State.IDLE)
