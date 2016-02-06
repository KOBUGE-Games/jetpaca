# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

export var fruit_index=0

func _on_timeout():
	queue_free()
	
func _on_enter_screen():
	get_node("anim").play("roll")
	
func _on_exit_screen():
	get_node("anim").stop()

func _on_body_enter( body ):

	if (body extends preload("res://player/alpaca.gd")):
		print("BODY IN COIN")
		body.add_large_fruit(fruit_index)
		var gd = get_tree().get_root().get_node("game_data")
		print("PRE-SET ",gd.current_large_fruits)
		gd.current_large_fruits[fruit_index]=true
		print("POST-SET ",gd.current_large_fruits)
		get_node("sprite").hide()
		get_node("shine").set_emitting(true)
		get_node("sound").play("shine")
		get_node("deathclock").start()

func _ready():
	# Initalization here
	var cw = get_tree().get_root().get_node("game_data").current_world
	if (cw.large_fruits[fruit_index]):
		get_node("sprite").set_self_opacity(0.5)
		
	


