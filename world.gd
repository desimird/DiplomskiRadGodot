extends Node2D

@export var enemy: PackedScene


@onready var game_over = $Camera2D/CanvasLayer2/GameOver
@onready var go_popup = $Camera2D/CanvasLayer/go_popup
@onready var go_popup_timer = $go_popup_timer
@onready var camera_2d = $Camera2D
@onready var enemies = $Enemies

var enemies_spawned = true


func _ready():
	game_over.visible = false
	Global.paused = false
	Global.world = self
	PlayerStats.connect("no_health", Callable(self, "on_player_no_health"))
	Event.connect("triger_entered", Callable(self,"_on_triger_entered"))

func _process(delta):
	#fix camera limits when entering areas of right but when level is all done should be easy to hard code it in design
	if Input.is_action_just_pressed("cam_test_down"):
		camera_2d.limit_right += 240
	if enemies.get_child_count() == 0 and enemies_spawned:
		go_popup_timer.start()
		go_popup.visible = true
		camera_2d.limit_right += 240
		
		enemies_spawned = false


func instance_node(node, location):
	
	var node_instance = node.instance()
	add_child(node_instance)
	node_instance.global_position = location 

func on_player_no_health():
	game_over.visible = true
	game_over.play_anim()
	Global.paused = true
	


func _on_go_popup_timer_timeout():
	go_popup.visible = false

func _on_triger_entered(position_x):
	call_deferred("_spawn_enemies", position_x)
	

func _spawn_enemies(position_x):
	for i in range(2):
		var node_insance = enemy.instantiate()
		enemies.add_child(node_insance)
		node_insance.global_position = Vector2(position_x + i*5 + 240, 120)
	enemies_spawned = true
