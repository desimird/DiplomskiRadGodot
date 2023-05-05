extends Node2D

@export var enemy: PackedScene
@export var enemy2: PackedScene
@export var enemy3: PackedScene


@onready var game_over = $Camera2D/CanvasLayer2/GameOver
@onready var go_popup = $Camera2D/CanvasLayer/go_popup
@onready var go_popup_timer = $go_popup_timer
@onready var camera_2d = $Camera2D
@onready var enemies = $Enemies
@onready var block_behind = $BlockBehind
@onready var block_front = $BlockFront
@onready var win = $Camera2D/CanvasLayer2/Win


var limits = [240, 600, 1200, 1200,1800,1800, 2500, 2500, 2500, 2500, 25000,25000]

var enemies_spawned = true
var player_x_max = 120
var triger_counter = 0

func _ready():
	game_over.visible = false
	win.visible = false
	Global.paused = false
	Global.world = self
	PlayerStats.connect("no_health", Callable(self, "on_player_no_health"))
	Event.connect("triger_entered", Callable(self,"_on_triger_entered"))


func _process(delta):
	camera_2d.limit_right = limits[triger_counter]
	block_front.global_position.x = camera_2d.limit_right + 20
	if Global.player_pos.x > player_x_max:
		if abs(camera_2d.limit_right - Global.player_pos.x) > 119:
			player_x_max = Global.player_pos.x
			camera_2d.limit_left = player_x_max - 120
			block_behind.global_position.x = camera_2d.limit_left
	#fix camera limits when entering areas of right but when level is all done should be easy to hard code it in design
	if Input.is_action_just_pressed("cam_test_down"):
		camera_2d.limit_right += 240
	if enemies.get_child_count() == 0 and enemies_spawned:
		#spawner_count += 1
		if triger_counter == 8:
			win.visible = true
			win.play_anim()
		go_popup_timer.start()
		go_popup.visible = true
		#camera_2d.limit_right += 240
		#camera_2d.limit_right = spawner_count * 600
		enemies_spawned = false


func instance_node(node, location):
	call_deferred("_instance_node_call", node, location)
	

func _instance_node_call(node, location):
	var node_instance = node.instantiate()
	add_child(node_instance)
	node_instance.global_position = location 

func on_player_no_health():
	game_over.visible = true
	game_over.play_anim()
	Global.paused = true
	


func _on_go_popup_timer_timeout():
	go_popup.visible = false
	#SoundPlayer.stop_all()

func _on_triger_entered(position_x, num, type):
	triger_counter += 1
	print(triger_counter)
	call_deferred("_spawn_enemies", position_x, num, type)
	

func _spawn_enemies(position_x, num, type):
	#spawner_count += 1
	#camera_2d.limit_right = spawner_count * 600
	if type == 1:
		for i in range(num):
			var node_insance = enemy.instantiate()
			enemies.add_child(node_insance)
			node_insance.global_position = Vector2(position_x + i*10 + 240, 120 + i*20)
		enemies_spawned = true
	if type == 2:
		for i in range(num):
			var node_insance = enemy2.instantiate()
			enemies.add_child(node_insance)
			node_insance.global_position = Vector2(position_x + i*10 + 240, 120 + i*20)
		enemies_spawned = true
	if type == 3:
		for i in range(num):
			var node_insance = enemy3.instantiate()
			enemies.add_child(node_insance)
			node_insance.global_position = Vector2(position_x + i*10 + 240, 120 + i*20)
		enemies_spawned = true
