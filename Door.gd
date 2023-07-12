extends Area2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $StaticBody2D/CollisionShape2D

@export var scene_to: String

var door_opened = false
var door_can_open = false
# Called when the node enters the scene tree for the first time.
func _ready():
	Event.connect("open_door", Callable(self,"_on_open_door"))
	collision_shape_2d.disabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if not body is Player: return
	if not door_opened: return
	get_tree().change_scene_to_file(scene_to)


func _on_open_door():
	if door_opened: return
	door_can_open = true
	


func _on_animated_sprite_2d_animation_finished():
	door_opened = true
	collision_shape_2d.disabled = true
	


func _on_area_2d_body_entered(body):
	if not body is Player: return
	if door_opened: return
	if door_can_open:
		animated_sprite_2d.play("default")
