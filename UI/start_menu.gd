extends Control

var can_input = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("attack") and can_input:
		get_tree().change_scene_to_file("res://world.tscn")


func _on_animation_player_animation_finished(anim_name):
	can_input = true
