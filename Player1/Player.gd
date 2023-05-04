extends CharacterBody2D
class_name Player

@export var MAX_SPEED: int = 80
@export var ACCELERATION: int = 1000
@export var FRICTION: int = 5000
#@export var gameover_popup: PackedScene

var paused = false

var input_vector = Vector2.ZERO

var combo_count = 0



@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
#@onready var player_stats = $PlayerStats
@onready var player_hurtbox = $PlayerHurtbox
@onready var sword_hitbox = $HitboxPivot/SwordHitbox
@onready var timer = $Timer
@onready var animated_sprite_2d = $AnimatedSprite2D



#@onready var projectile = preload("res://World/projectile.tscn")

signal popup_gms(node,location)

enum{
	MOVE,
	ROLL,
	ATTACK,
	IDLE
}
var state = MOVE


# Called when the node enters the scene tree for the first time.
func _ready():
	player_hurtbox.connect("hitted", Callable(self, "_on_hitted"))
	PlayerStats.connect("no_health", Callable(self, "_on_no_health"))
	sword_hitbox.connect("did_hit", Callable(self, "_on_did_hit"))
	#player_stats.connect("no_health", self, "change_screen")

func _physics_process(delta):
	#print(combo_count)
#	update()
	if Global.paused:
		return 1
	else:
		if Global.world != null:
			if !is_connected("popup_gms", Callable(Global.world, "popup_gms")):
				connect("popup_gms", Callable(Global.world, "popup_gms"))
		Global.player_pos = global_position
		match state:
			MOVE:
				move_state(delta)
			ATTACK:
				attack_state(delta)




func move_state(delta):
	
	if Input.is_action_just_pressed("attack"):
		if (animation_tree.get("parameters/attack/blend_position").y == 0):
			timer.start()
			state = ATTACK
	
	input_vector.x= Input.get_action_strength("ui_right")- Input.get_action_strength("ui_left")
	input_vector.y= Input.get_action_strength("ui_down")- Input.get_action_strength("ui_up")
	input_vector= input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		sword_hitbox.knockback_vector = input_vector
		#Global.projectile_knockback_vector = input_vector
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/attack/blend_position", input_vector)
		if combo_count == 0:
			animation_state.travel("Run")
		velocity = input_vector * MAX_SPEED
	else:
		velocity = Vector2.ZERO
		if combo_count == 0:
			animation_state.travel("Idle")
		
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity
	
	
		#var pos = global_position
		#Event.emit_signal("shots_fired", projectile, pos,animation_tree.get("parameters/attack/blend_position"))
#		if Global.sword_duration > 0:
#
#			Global.sword_duration -= 1
			#(Global.sword_duration)
		

func _on_did_hit():
	combo_count += 1
	sword_hitbox.combo_count = combo_count
	if combo_count > 3:
		combo_count = 0
		sword_hitbox.combo_count = combo_count

func attack_state(delta):
	animation_state.travel("attack")
	animated_sprite_2d.set("frame",combo_count-1)

func attack_anim_finished():
	state = MOVE

func _on_hitted():
	#print("USO")
	#SoundPlayer.play_sound(SoundPlayer.PLAYER_DMG)
	PlayerStats.set_health(PlayerStats.health - 1)
	

func recicle():
	#Event.emit_signal("recycle")
#	while(Global.tin_collected >= 1):
#		SoundPlayer.play_sound(SoundPlayer.SWORD_GET)
#		Global.sword_duration += 2
#		oneup.play("oneup")
#		Global.tin_collected -= 1
	pass
		
func _on_no_health():
#	emit_signal("popup_gms",gameover_popup, Vector2(52,64))
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func _draw():
#	draw_circle(Vector2(0,0) + position, 10, Color.yellow)
#	print(global_position)


func _on_timer_timeout():
	combo_count = 0
	sword_hitbox.combo_count = combo_count
	state = MOVE
