# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends "res://enemies/enemy.gd"

# member variables here, example:
# var a=2
# var b="textvar"


func inflicts_damage():
	return false

func takes_damage():
	return true

func attacked(s):
	if (s extends preload("res://player/alpaca.gd")):
		get_node("../particles").set_emitting(true)
		get_node("../sample").play("rock_explode")
		#clear_shapes()
		#hide()
		queue_free()
		
	
func _ready():
	# Initalization here
	pass


