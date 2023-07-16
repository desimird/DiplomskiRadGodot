extends CharacterBody2D


var player_near = false
var picked_up = false
var just_picked_up = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(player_near)
	if player_near and Input.is_action_just_pressed("pickup"):
		picked_up = true
		just_picked_up = true
		
	if picked_up:
		global_position.x = Global.player_pos.x
		global_position.y = Global.player_pos.y - 25
		
		if Input.is_action_just_pressed("pickup") and not just_picked_up:
			velocity = Vector2(100,0)
			picked_up = false
		else:
			if velocity.x > 0:
				velocity.x = velocity.x - 10
	
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity
	just_picked_up = false

func _on_area_2d_body_entered(body):
	if not body is Player: return
	player_near = true
	


func _on_area_2d_body_exited(body):
	if not body is Player: return
	if not player_near: return
	player_near = false
