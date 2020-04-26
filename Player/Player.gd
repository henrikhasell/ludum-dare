extends RigidBody2D


enum Direction {
	UP, DOWN, LEFT, RIGHT
}

enum State {
	ATTACK, IDLE, WALKING
}

const movement_animations: Dictionary = {
	Direction.UP: "walk_up",
	Direction.DOWN: "walk_down",
	Direction.LEFT: "walk_left",
	Direction.RIGHT: "walk_right"
}

const attack_animations: Dictionary = {
	Direction.UP: "axe_up",
	Direction.DOWN: "axe_down",
	Direction.LEFT: "axe_left",
	Direction.RIGHT: "axe_right"
}

var player_direction = Direction.RIGHT
var player_state = State.IDLE
var movement_speed: int = 200


onready var animation_player: AnimationPlayer = get_node(@"Sprite/AnimationPlayer")


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	var attack: bool = Input.is_action_pressed("attack")
	var move_up: bool = Input.is_action_pressed("move_up")
	var move_down: bool = Input.is_action_pressed("move_down")
	var move_left: bool = Input.is_action_pressed("move_left")
	var move_right: bool = Input.is_action_pressed("move_right")
	var desired_velocity: Vector2 = Vector2.ZERO

	if attack:
		animation_player.play(attack_animations[player_direction])
		player_state = State.ATTACK
	else:
		if move_left:
			desired_velocity.x -= movement_speed
			player_direction = Direction.LEFT
		elif move_right:
			desired_velocity.x += movement_speed
			player_direction = Direction.RIGHT
		elif move_up:
			desired_velocity.y -= movement_speed
			player_direction = Direction.UP
		elif move_down:
			desired_velocity.y += movement_speed
			player_direction = Direction.DOWN
	
		if desired_velocity != Vector2.ZERO:
			player_state = State.WALKING
		else:
			player_state = State.IDLE
	
		animation_player.play(movement_animations[player_direction])
	
		if player_state == State.IDLE:
			animation_player.stop(false)

	state.set_linear_velocity(desired_velocity)
