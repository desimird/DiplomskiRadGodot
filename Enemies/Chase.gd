extends EnemyState

@export var _animation_player: NodePath
@onready var animation_player: AnimationPlayer = get_node(_animation_player)


func enter(_msg := {}) -> void:
	animation_player.play("run")
	enemy.idle_timer.start()
	enemy.chase_state_just_entered = false
func physics_update(delta: float) -> void:
	enemy.knockback = enemy.knockback.move_toward(Vector2.ZERO,200*delta)
	enemy.set_velocity(enemy.knockback)
	enemy.move_and_slide()
	enemy.knockback = enemy.velocity
	
	enemy.direction = (Global.player_pos - enemy.global_position).normalized()
	#direction.y = sign(direction.y)* (abs(direction.y) + 1)
	enemy.velocity = enemy.MAX_SPEED * enemy.direction
	enemy.set_velocity(enemy.velocity)
	enemy.move_and_slide()
	
	if enemy.attack:
		state_machine.transition_to("Attack", {})
	elif enemy.hitted:
		state_machine.transition_to("Hitted", {})
	elif enemy.idle_timer_timeout:
		state_machine.transition_to("Idle", {})
	

		

	
	
