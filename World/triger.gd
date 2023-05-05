extends Area2D


@onready var triggered = false
@export var number_of_enemies = 2
@export var type_of_enemies = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	#monitoring = false
	if not body is Player: return
	#print(global_position.x)
	if not triggered:
		print("uso")
		Event.emit_signal("triger_entered",global_position.x,number_of_enemies,type_of_enemies)
		triggered = true
