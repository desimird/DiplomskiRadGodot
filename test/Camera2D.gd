extends Camera2D

@onready var topLeft = $Limits/TopLeft
@onready var bottomRight = $Limits/BottomRight
@onready var area_2d = $Area2D


func _ready():
	limit_top = topLeft.position.y
	limit_bottom = bottomRight.position.y

func _on_area_2d_area_entered(area):
	limit_left = area.global_position.x
