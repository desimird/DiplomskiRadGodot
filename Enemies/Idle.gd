extends EnemyState

@export var _animation_player: NodePath
@onready var animation_player: AnimationPlayer = get_node(_animation_player)


func enter(_msg := {}) -> void:
	enemy.idle_timer_timeout = false
	animation_player.play("idle")
	
func physics_update(delta: float) -> void:
	enemy.velocity = Vector2.ZERO
	enemy.set_velocity(enemy.velocity)
	enemy.move_and_slide()
	if enemy.direction_change_timer > 0.0:
		enemy.direction_change_timer -= delta
	else:
		if enemy.attack_range_2.get_overlapping_bodies().is_empty():
			state_machine.transition_to("Chase", {})
	
	
	if enemy.attack:
		state_machine.transition_to("Attack", {})
	elif enemy.hitted:
		state_machine.transition_to("Hitted", {})
	elif enemy.idle_timer_timeout:
		state_machine.transition_to("Idle", {})
	
	
