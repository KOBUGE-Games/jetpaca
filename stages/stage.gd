# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Node

func level_end():
	game_data.stage_clear()
	main.goto_scene("res://menu/stage_select.tscn")

func restart():
	if game_data.life_count < 0: # Out of lives
		game_data.game_over()
		main.goto_scene("res://menu/stage_select.tscn")
	else: # Restart level
		var wpc = game_data.current_world.path
		main.goto_scene(wpc)

func _enter_tree():
	game_data.set_current_stage(get_filename())
	var charnode = preload("res://player/alpaca.tscn").instance()
	get_node("launch").add_child(charnode)
	game_data.current_big_coins = [false, false, false]
	for x in game_data.current_world.big_coins:
		game_data.current_big_coins.push_back(x)
