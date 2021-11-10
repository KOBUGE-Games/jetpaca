# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Node

const TRANSITION_TIME = 1.0

onready var tween = get_node("tween")
var current_music_player = null
var current_music = ""

func _ready():
	change_music_to("res://music/bgm.ogg")

func restart_music():
	change_music_to(current_music, true)

func change_music_to(path, force=false):
	if current_music == path && !force:
		return
	current_music = path
	var stream = load(path)
	var new_music_player = AudioStreamPlayer.new()
	new_music_player.bus = "Music"
	new_music_player.set_autoplay(true)
	new_music_player.set_stream(stream)
	if current_music_player:
		new_music_player.set_volume_db(-80)
		tween.interpolate_property(
			current_music_player, "volume_db",
			current_music_player.get_volume_db(), -32,
			TRANSITION_TIME, Tween.TRANS_EXPO, Tween.EASE_IN)
		tween.interpolate_callback(current_music_player, TRANSITION_TIME, "queue_free")
		tween.interpolate_property(
			new_music_player, "volume_db",
			-32, 0,
			TRANSITION_TIME, Tween.TRANS_EXPO, Tween.EASE_OUT, TRANSITION_TIME)
		tween.start()
	current_music_player = new_music_player
	add_child(new_music_player)
