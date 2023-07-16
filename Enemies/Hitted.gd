extends EnemyState

@export var _animation_player: NodePath
@onready var animation_player: AnimationPlayer = get_node(_animation_player)


func enter(_msg := {}) -> void:
	enemy.attacking = false
	enemy.attack_range.monitoring = false
	enemy.attack_speed.start()
	enemy.enemy_hitbox.monitoring = false
	if enemy.hitted_hard:
		animation_player.play("hitted_hard")
	else:
		print("uso")
		animation_player.play("hitted")
		
func physics_update(delta: float) -> void:
	enemy.knockback = enemy.knockback.move_toward(Vector2.ZERO,200*delta)
	enemy.set_velocity(enemy.knockback)
	enemy.move_and_slide()
	enemy.knockback = enemy.velocity
	
	if not animation_player.is_playing():
		enemy.hitted = false
		if enemy.hitted_hard: enemy.hitted_hard = false
		enemy.stats.set_health(enemy.stats.health - 1)
		state_machine.transition_to("Idle", {})
	
	
