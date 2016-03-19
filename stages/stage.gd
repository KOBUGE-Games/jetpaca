# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Node

# member variables here, example:
# var a=2
# var b="textvar"


func level_end():
	var gd = get_tree().get_root().get_node("game_data")
	gd.stage_clear()
	get_tree().get_root().get_node("main").goto_scene("res://menu/stage_select.tscn")

func restart():
	var gd = get_tree().get_root().get_node("game_data")
	if (gd.life_count<0): 
		#out of lifes
		gd.game_over()
		get_tree().get_root().get_node("main").goto_scene("res://menu/stage_select.tscn")
	else:
		#restart level
		var wpc = gd.current_world.path
	# 	get_tree().get_root().get_node("game_data").current_checkpoint=null
		get_tree().get_root().get_node("main").goto_scene(wpc)
	


func _enter_tree():

	get_tree().get_root().get_node("game_data").make_world_current(get_filename())
	var charnode = preload("res://player/alpaca.tscn").instance()
	get_node("launch").add_child(charnode)
	var gd = get_tree().get_root().get_node("game_data")
	gd.current_large_fruits=[false,false,false]
	for x in gd.current_world.large_fruits:
		gd.current_large_fruits.push_back(x)


	

func _ready():
	# Initalization here
	pass


