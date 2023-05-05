extends Node

const PLAYER_HURT = preload("res://Sounds/player_hurt.wav")
const ENEMY_DEAD = preload("res://Sounds/enemy_dead.wav")
const HIT = preload("res://Sounds/Hit.wav")
const PICKUP = preload("res://Sounds/pickup.wav")
const NEXT = preload("res://Sounds/next.wav")
const LOSE = preload("res://Sounds/lose.wav")
const START = preload("res://Sounds/startscreen.wav")

@onready var audio_players: = $AudioPlayers

func play_sound(sound):
	for audio_stream_player in audio_players.get_children():
		if not audio_stream_player.playing:
			audio_stream_player.stream = sound
			audio_stream_player.play()
			break
			

func stop_all():
	for audio_stream_player in audio_players.get_children():
		if audio_stream_player.playing:
			audio_stream_player.stop()
