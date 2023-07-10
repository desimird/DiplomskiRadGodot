extends CharacterBody2D
class_name WalkingEnemy


const MIN_DIRECTION_CHANGE_DELAY = 1.0
const MAX_DIRECTION_CHANGE_DELAY = 2.0

@export var SPEED = 25
@export var MAX_SPEED: int = 30
@export var glasses: PackedScene

@onready var enemy_hurtbox = $EnemyHurtbox
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var hitbox_pivot = $HitboxPivot
@onready var enemy_hitbox = $HitboxPivot/EnemyHitbox
@onready var attack_range = $AttackRange
@onready var attack_speed = $AttackSpeed
@onready var attack_range_2 = $AttackRange2
@onready var idle_timer = $IdleTimer
@onready var stats = $Stats
@onready var soft_collision = $SoftCollision




signal instance_node(node, location)

var knockback = Vector2.ZERO
var paused = false
var attacking = false
var direction = Vector2.RIGHT
var direction_change_timer = 0.0
var hitted_hard = false
var chase_state_just_entered = true
var death_animation_playing = false
var hitted = false
var attack = false
var idle_timer_timeout = false


func _ready():
	randomize()
	enemy_hurtbox.connect("hitted", Callable(self, "_on_hitted"))
	enemy_hurtbox.connect("hitted_hard", Callable(self, "_on_hitted_hard"))
	stats.connect("no_health", Callable(self, "_on_no_health"))
	
func _physics_process(delta):
	if Global.paused or paused:
		return 1
	else:
		animated_sprite_2d.flip_h = direction.x < 0
		
		if direction.x > 0:
			hitbox_pivot.rotation_degrees = -180
			attack_range.rotation_degrees = -180
			attack_range_2.rotation_degrees = -180
		else:
			hitbox_pivot.rotation_degrees = 0
			attack_range.rotation_degrees = 0
			attack_range_2.rotation_degrees = 0
			
		if soft_collision.is_colliding():
			#print("AA")
			#state = SOFT
			velocity = soft_collision.get_push_vector() * MAX_SPEED
			set_velocity(velocity)
			move_and_slide()
			#fix this 


func _on_hitted():
	if not attacking:
		knockback = enemy_hurtbox.knock * 100
		hitted = true

func _on_hitted_hard():
	if not attacking:
		knockback = enemy_hurtbox.knock * 100
		hitted_hard = true
		hitted = true
	#stats.set_health(stats.health - 1)

func _on_no_health():
	SoundPlayer.play_sound(SoundPlayer.ENEMY_DEAD)
	if global_position.y < 135:
		emit_signal("instance_node", glasses, Vector2(global_position.x,135))
	else:
		emit_signal("instance_node", glasses, global_position)
	queue_free()
	
func _process(delta):
	if Global.world != null:
		if !is_connected("instance_node", Callable(Global.world, "instance_node")):
			connect("instance_node", Callable(Global.world, "instance_node"))
	
func random_direction():
	var directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN,Vector2(1,1),Vector2(-1,1),Vector2(1,-1),Vector2(-1,-1), Vector2(15,15)]
	return directions[randi() % directions.size()]

func _on_attack_speed_timeout():
	attack_range.monitoring = true

func _on_idle_timer_timeout():
	idle_timer_timeout = true
	direction_change_timer = randf_range(MIN_DIRECTION_CHANGE_DELAY, MAX_DIRECTION_CHANGE_DELAY)
	chase_state_just_entered = true

func _on_attack_range_area_entered(area):
	if not area.get_parent() is Player: return
	attack = true





