extends Area2D

@export var shadow_drawer: PackedScene
@onready var sprite_2d = $Sprite2D


var rng = RandomNumberGenerator.new()
var z = 3.5
var z_timer = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	var shadow_drawer_instance = shadow_drawer.instantiate()
	
	add_child(shadow_drawer_instance)
	z += rng.randf_range(1.75, 2.25)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	z = z + sin(z_timer * 0.05) * 0.005
	z_timer += 0.08
	sprite_2d.global_position.y = global_position.y - z


func _on_body_entered(body):
	#print(body)
	
	if not body is Player: return
	SoundPlayer.play_sound(SoundPlayer.PICKUP)
	PlayerStats.set_health(PlayerStats.max_health)
	queue_free()
