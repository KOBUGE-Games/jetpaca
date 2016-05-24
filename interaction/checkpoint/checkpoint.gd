# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

var checked=false

func _on_body_enter(body):
	
	if (not checked and body extends preload("res://player/alpaca.gd")):
		get_node("anim").play("checked")
		get_node("tune").play()
		checked=true
		var gd = get_tree().get_root().get_node("game_data")
		gd.current_checkpoint=get_path()
		var cw = gd.current_world
		cw.big_coins=[]
		body.restore_life(2)
#		gd.current_world.big_coins=[] bug
		
		# save the amount of large fruits collected
		for x in gd.current_big_coins: 
			cw.big_coins.push_back(x)
		

func _ready():
	# Initalization here
	pass


