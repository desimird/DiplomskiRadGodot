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
	
	#if not area.get_parent() is Projectile: return
	#print(area.get_parent() is Projectile)
	#print(area.combo_count)
	if area.combo_count == 2:
		knock = area.knockback_vector * 1.3
		emit_signal("hitted_hard")
	else:
		
		knock = area.knockback_vector * 0 
		emit_signal("hitted") 
	#area.get_parent().queue_free()
	#print("hitted")
	
