# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Area2D

var checked = false

func _on_body_enter(body):
	if not checked and body is preload("res://player/alpaca.gd"):
		get_node("anim").play("checked")
		get_node("tune").play()
		checked = true
		game_data.current_checkpoint = get_path()
		var cw = game_data.current_world
		cw.big_coins = []
		body.restore_life(2)

		# Save the amount of large fruits collected
		for x in game_data.current_big_coins:
			cw.big_coins.push_back(x)

