extends PlayerState

@export var _animation_player: NodePath
@onready var animation_player: AnimationPlayer = get_node(_animation_player)


@export var animation_left: String
@export var animation_right: String
@export var next_state: String

var action_pressed = false

func enter(_msg := {}) -> void:
	player.hitted = false
	player.get_input_vector()
	if player.animated_sprite_2d.flip_h:
		animation_player.play(animation_left)
	else:
		animation_player.play(animation_right)
	player.can_input = false
	action_pressed = false
	
	
	
func physics_update(delta: float) -> void:
	player.get_input_vector()
	player.velocity = Vector2.ZERO
	player.set_velocity(player.velocity)
	player.set_up_direction(Vector2.UP)
	player.move_and_slide()
	player.velocity = player.velocity
	
	if Input.is_action_just_pressed("attack"):
		action_pressed = true
		
	if next_state and player.can_input and action_pressed and player.did_hit:
		player.did_hit = false
		state_machine.transition_to(next_state, {})
	
	if not animation_player.is_playing() or player.input_vector != Vector2.ZERO:
		player.did_hit = false
		state_machine.transition_to("Idle", {})


