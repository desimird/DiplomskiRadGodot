extends PlayerState

@export var _animation_player: NodePath
@onready var animation_player: AnimationPlayer = get_node(_animation_player)


func enter(_msg := {}) -> void:
	player.get_input_vector()
	animation_player.play("hitted")
	
func physics_update(delta: float) -> void:
	if not player.hitted:
		state_machine.transition_to("Idle", {})
