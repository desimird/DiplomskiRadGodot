extends CharacterBody2D
class_name Player

@export var MAX_SPEED: int = 80
@export var ACCELERATION: int = 1000
@export var FRICTION: int = 5000
#@export var gameover_popup: PackedScene

var paused = false


var input_vector = Vector2.ZERO

var combo_count = 0

var attack_state_finished = true

var can_input = true
var did_hit = false
var hitted = false
var died = false
var falling = false

@onready var animation_player = $AnimationPlayer
#@onready var player_stats = $PlayerStats
@onready var player_hurtbox = $PlayerHurtbox
@onready var sword_hitbox = $HitboxPivot/SwordHitbox
@onready var timer = $Timer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var died_anim = $Died_anim



#@onready var projectile = preload("res://World/projectile.tscn")

signal popup_gms(node,location)



func _ready():
	player_hurtbox.connect("hitted", Callable(self, "_on_hitted"))
	PlayerStats.connect("no_health", Callable(self, "_on_no_health"))
	sword_hitbox.connect("did_hit", Callable(self, "_on_did_hit"))
	#player_stats.connect("no_health", self, "change_screen")
	
func _physics_process(delta):
	#print(did_hit)
	get_input_vector()
	if Global.paused:
		return 1
	else:
		if Global.world != null:
			if !is_connected("popup_gms", Callable(Global.world, "popup_gms")):
				connect("popup_gms", Callable(Global.world, "popup_gms"))
		Global.player_pos = global_position

func get_input_vector():
	if not can_input:
		input_vector = Vector2.ZERO
		return
	input_vector.x= Input.get_action_strength("ui_right")- Input.get_action_strength("ui_left")
	input_vector.y= Input.get_action_strength("ui_down")- Input.get_action_strength("ui_up")
	input_vector= input_vector.normalized()
	
	if input_vector.x > 0:
		animated_sprite_2d.flip_h = false
		died_anim.flip_h = false
	if input_vector.x < 0:
		animated_sprite_2d.flip_h = true
		died_anim.flip_h = true

func ready_for_input():
	Global.hard_hit = false
	can_input = true
	
func _on_did_hit():
	SoundPlayer.play_sound(SoundPlayer.HIT)

func attack_anim_finished():
	attack_state_finished = true
	
func _on_hitted():
	SoundPlayer.play_sound(SoundPlayer.PLAYER_HURT)
	PlayerStats.set_health(PlayerStats.health - 1)
	hitted = true

func _on_no_health():
#	emit_signal("popup_gms",gameover_popup, Vector2(52,64))

	#animation_player.play("falling")
	#SoundPlayer.play_sound(SoundPlayer.LOSE)
	falling = true

func _on_timer_timeout():
	combo_count = 0
	sword_hitbox.combo_count = combo_count
	#state = MOVE

func _on_hitted_animation_finished():
	hitted = false

func done_falling():
	falling = false

func end_game():
	queue_free()

func _set_hard_hit():
	Global.hard_hit = true
