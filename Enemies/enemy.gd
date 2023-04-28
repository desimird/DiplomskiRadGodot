extends CharacterBody2D
class_name WalkingEnemy


const MIN_DIRECTION_CHANGE_DELAY = 0.5
const MAX_DIRECTION_CHANGE_DELAY = 1.0

@export var SPEED = 25
@export var MAX_SPEED: int = 10

@onready var enemy_hurtbox = $EnemyHurtbox
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var hitbox_pivot = $HitboxPivot
@onready var enemy_hitbox = $HitboxPivot/EnemyHitbox
@onready var attack_range = $AttackRange
@onready var ray_cast_2d = $RayCast2D
@onready var ray_cast_2d_2 = $RayCast2D2
@onready var attack_speed = $AttackSpeed
@onready var attack_range_2 = $AttackRange2
@onready var player_detection = $PlayerDetection


signal instance_node(node, location)

var knockback = Vector2.ZERO
var paused = false
var attacking = false
var direction = Vector2.RIGHT
var direction_change_timer = 0.0
var hitted_hard = false

enum{
	WONDER,
	IDLE,
	HITTED,
	CHASE,
	ATTACK
}
var state = WONDER


func _ready():
	randomize()
	enemy_hurtbox.connect("hitted", Callable(self, "_on_hitted"))
	enemy_hurtbox.connect("hitted_hard", Callable(self, "_on_hitted_hard"))
	#stats.connect("no_health", Callable(self, "_on_no_health"))

func _physics_process(delta):
	if Global.paused or paused:
	#	animated_sprite.pause()
		return 1
	else:
		animated_sprite_2d.flip_h = direction.x > 0
		
		if direction.x > 0:
			hitbox_pivot.rotation_degrees = -180
			attack_range.rotation_degrees = -180
			attack_range_2.rotation_degrees = -180
		else:
			hitbox_pivot.rotation_degrees = 0
			attack_range.rotation_degrees = 0
			attack_range_2.rotation_degrees = 0
			
		match state:
			WONDER:
				wonder_state(delta)
			IDLE:
				idle_state(delta)
			HITTED:
				hitted_state(delta)
			CHASE:
				chase_state(delta)
			ATTACK:
				attack_state(delta)

	#	animated_sprite.play()
	#print(stats.health)
		
		
		#if soft_collition.is_colliding():
		#	velocity+= soft_collition.get_push_vector()*delta*400
		
		#a#nimated_sprite.flip_h = direction.x < 0
		
		#velocity = move_and_slide(velocity, Vector2.UP)

func wonder_state(delta):
	animated_sprite_2d.play("run")
	knockback = knockback.move_toward(Vector2.ZERO,200*delta)
	set_velocity(knockback)
	move_and_slide()
	knockback= velocity
	
	if(ray_cast_2d.get_collider() or ray_cast_2d_2.get_collider()):
		state = CHASE
	
	if player_in_site():
		state = CHASE
	
	var direction_old = Vector2.ZERO
	velocity = direction.normalized() * SPEED * delta
	var collision = move_and_collide(velocity)
	if collision and not collision.get_collider() is Player:
		direction_old = direction
		direction = random_direction()
		direction_change_timer = randf_range(MIN_DIRECTION_CHANGE_DELAY, MAX_DIRECTION_CHANGE_DELAY)
		if(direction == Vector2(15,15)):
			direction = direction_old
			state = IDLE
	if direction_change_timer > 0.0:
		direction_change_timer -= delta
	else:
		direction = random_direction()
		direction_change_timer = randf_range(MIN_DIRECTION_CHANGE_DELAY, MAX_DIRECTION_CHANGE_DELAY)
		if(direction == Vector2(15,15)):
			direction = direction_old
			state = IDLE

		velocity = MAX_SPEED*direction

func idle_state(delta):
	animated_sprite_2d.play("idle")
	velocity = Vector2.ZERO
	if direction_change_timer > 0.0:
		direction_change_timer -= delta
	else:
		if not attack_range_2.get_overlapping_bodies().is_empty():
				for i in range(attack_range_2.get_overlapping_bodies().size()):
					if attack_range_2.get_overlapping_bodies()[i] is Player:
						state = IDLE
						#_on_attack_animation_ended()
		else:
			state = WONDER
	
func hitted_state(delta):
	attacking = false
	attack_range.monitoring = false
	attack_speed.start()
	enemy_hitbox.monitoring = false
	knockback = knockback.move_toward(Vector2.ZERO,200*delta)
	set_velocity(knockback)
	move_and_slide()
	knockback= velocity
	
	#_on_attack_animation_ended()
	
	
	if hitted_hard:
		animation_player.play("hitted_hard")
	else:
		animation_player.play("hitted")
	
func chase_state(delta):
	animated_sprite_2d.play("run")
	knockback = knockback.move_toward(Vector2.ZERO,200*delta)
	set_velocity(knockback)
	move_and_slide()
	knockback= velocity
	
	direction = (Global.player_pos - global_position).normalized()
	print(direction)
	velocity = MAX_SPEED*direction
	set_velocity(velocity)
	move_and_slide()
	
	if not(ray_cast_2d.get_collider() or ray_cast_2d_2.get_collider()):
		state = WONDER

func attack_state(delta):
	enemy_hitbox.monitoring = true
	
	if not attacking:
		if randi() % 2 == 0:
			animation_player.play("attack_1")
		else:
			animation_player.play("attack_2")
	
	attacking = true
	
	

func _on_hitted():
	if not attacking:
		knockback = enemy_hurtbox.knock * 100
		state = HITTED

func _on_hitted_hard():
	if not attacking:
		knockback = enemy_hurtbox.knock * 100
		
		hitted_hard = true
		state = HITTED
	#stats.set_health(stats.health - 1)

func _on_hitted_animation_ended():
	state = IDLE
	if hitted_hard: hitted_hard = false
	
func _on_attack_animation_ended():
	attacking = false
	attack_range.monitoring = false
	attack_speed.start()
	enemy_hitbox.monitoring = false
	state = IDLE
	
func _on_no_health():
	#SoundPlayer.play_sound(SoundPlayer.ENEMY_DEATH)
	#Global.enemies_died += 1
	#Global.enemies_died_high += 1
	#emit_signal("instance_node", tin_can, global_position)
	queue_free()

func _process(delta):
	if Global.world != null:
		if !is_connected("instance_node", Callable(Global.world, "instance_node")):
			connect("instance_node", Callable(Global.world, "instance_node"))
	
func random_direction():
	var directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN,Vector2(1,1),Vector2(-1,1),Vector2(1,-1),Vector2(-1,-1), Vector2(15,15)]
	return directions[randi() % directions.size()]

func _on_attack_range_body_entered(body):
	#print(body)
	if not body is Player: return
	if state != HITTED:
		print(body)
		state = ATTACK

func _on_attack_speed_timeout():
	attack_range.monitoring = true

func player_in_site():
	if not player_detection.get_overlapping_bodies().is_empty():
				for i in range(player_detection.get_overlapping_bodies().size()):
					if player_detection.get_overlapping_bodies()[i] is Player:
						print("uso")
						return true
	return false

