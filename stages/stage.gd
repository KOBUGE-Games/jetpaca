# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Node

func level_end():
	var gd = get_tree().get_root().get_node("game_data")
	gd.stage_clear()
	get_tree().get_root().get_node("main").goto_scene("res://menu/stage_select.tscn")

func restart():
	var gd = get_tree().get_root().get_node("game_data")
	if gd.life_count < 0: # Out of lives
		gd.game_over()
		get_tree().get_root().get_node("main").goto_scene("res://menu/stage_select.tscn")
	else: # Restart level
		var wpc = gd.current_world.path
	# 	get_tree().get_root().get_node("game_data").current_checkpoint = null
		get_tree().get_root().get_node("main").goto_scene(wpc)

func _enter_tree():
	get_tree().get_root().get_node("game_data").set_current_stage(get_filename())
	var charnode = preload("res://player/alpaca.tscn").instance()
	get_node("launch").add_child(charnode)
	var gd = get_tree().get_root().get_node("game_data")
	gd.current_big_coins = [false, false, false]
	for x in gd.current_world.big_coins:
		gd.current_big_coins.push_back(x)
