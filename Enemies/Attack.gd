extends EnemyState

@export var _animation_player: NodePath
@onready var animation_player: AnimationPlayer = get_node(_animation_player)


func enter(_msg := {}) -> void:
	enemy.attacking = true
	enemy.enemy_hitbox.monitoring = true
	if randi() % 2 == 0:
		animation_player.play("attack_1")
	else:
		animation_player.play("attack_2")
func physics_update(delta: float) -> void:
	enemy.velocity = Vector2.ZERO
	enemy.set_velocity(enemy.velocity)
	enemy.set_up_direction(Vector2.UP)
	enemy.move_and_slide()
	enemy.velocity = enemy.velocity
	
	if not animation_player.is_playing():
		enemy.attack = false
		enemy.attacking = false
		enemy.attack_range.monitoring = false
		enemy.attack_speed.start()
		enemy.enemy_hitbox.monitoring = false
		state_machine.transition_to("Idle", {})
	
	
