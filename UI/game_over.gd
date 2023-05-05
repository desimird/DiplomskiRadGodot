extends Control

@onready var sprite_2d_2 = $Sprite2D2
@onready var animation_player = $AnimationPlayer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player_2 = $AnimationPlayer2

var played = false
var anim_finished = false
var rng = RandomNumberGenerator.new()
var z = 0
var z_timer = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	z += rng.randf_range(1.75, 2.25)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	z = z + sin(z_timer * 0.05) * 0.005
	z_timer += 0.08
	sprite_2d_2.global_position.y = global_position.y + 171 - z
	
	if Input.is_action_just_pressed("attack") and anim_finished:
		PlayerStats.set_health(PlayerStats.max_health)
		get_tree().change_scene_to_file("res://world.tscn")

func play_anim():
	if not played:
		played = true
		animation_player.play("fade")
		animated_sprite_2d.global_position = Global.player_pos
		animation_player_2.play("new_animation")

func _on_button_pressed():
	PlayerStats.set_health(PlayerStats.max_health)
	get_tree().change_scene_to_file("res://world.tscn")


func _on_animation_player_animation_finished(anim_name):
	anim_finished = true
	
func play_sound():
	SoundPlayer.play_sound(SoundPlayer.START)
