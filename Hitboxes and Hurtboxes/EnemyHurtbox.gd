extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal hitted
signal hitted_hard

var knock = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EnemyHurtbox_area_entered(area):
	
	#print("udario")
	#print(area.get_parent().get_parent())
	if not area.get_parent().get_parent() is Player: return
	#print("enemy_hurt")
	#print(area.combo_count)
	#print(area.get_parent() is Projectile)
	#print(area.combo_count)
#	if area.combo_count == 3:
#		knock = area.knockback_vector * 1.3
#		emit_signal("hitted_hard")
#		#Event.emit_signal("reset_combo")
#		#area.combo_count = 0
#		#area.get_parent().get_parent().combo_count = 0
#	else:
#
#		knock = area.knockback_vector * 0 
#		emit_signal("hitted") 
#	#area.get_parent().queue_free()
#	#print("hitted")
	
