extends Node



@onready var sprite_2d = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position = get_parent().global_position
	sprite_2d.scale.x = 1 / (1 + (get_parent().z / 6))
	sprite_2d.scale.y = 1 / (1 + (get_parent().z / 6))
	
