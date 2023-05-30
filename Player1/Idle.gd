extends PlayerState

@export var _animation_player: NodePath
@onready var animation_player: AnimationPlayer = get_node(_animation_player)


func enter(_msg := {}) -> void:
	player.get_input_vector()
	animation_player.play("idle")
	
func physics_update(delta: float) -> void:
	#print("idle")
	player.get_input_vector()
	player.velocity = Vector2.ZERO
	player.set_velocity(player.velocity)
	player.set_up_direction(Vector2.UP)
	player.move_and_slide()
	player.velocity = player.velocity
	
	if player.falling:
		state_machine.transition_to("Died", {})
	
	if Input.is_action_just_pressed("attack"):
		player.timer.start()
		state_machine.transition_to("Attack1", {})
	elif player.hitted:
		state_machine.transition_to("Hitted", {})
	elif player.input_vector != Vector2.ZERO:
		state_machine.transition_to("Run", {})
	
	
