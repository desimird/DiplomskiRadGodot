extends Area2D
class_name Sword

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var knockback_vector = Vector2.ZERO
@onready var combo_count = 0
signal did_hit
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SwordHitbox_area_entered(area):
	if area.get_parent() is WalkingEnemy:
		emit_signal("did_hit")
		if combo_count == 3:
			area.knock = knockback_vector * 1.3
			area.emit_signal("hitted_hard")
		else:
			area.knock = knockback_vector * 0 
			area.emit_signal("hitted") 
	#area.get_parent().queue_free()
	#print("hitted")
	#if area.get_parent() is WalkingEnemy:
	#	SoundPlayer.play_sound(SoundPlayer.HIT_ENEMY)
		#area.emit_signal("hitted")
