extends Control


@onready var hp = $hp
@onready var num_of_glasses = $num_of_glasses


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(PlayerStats.health * 2.5)
	num_of_glasses.text = "X " + str(Global.glasses_collected)
	hp.value = (PlayerStats.health * 2.5)


