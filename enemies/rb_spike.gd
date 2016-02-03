# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends RigidBody2D



# member variables here, example:
# var a=2
# var b="textvar"


func _on_body_enter( body ):
	if (body extends preload("res://player/alpaca.gd")):
		body.hit_begin()

func _on_body_exit( body ):
	if (body extends preload("res://player/alpaca.gd")):
		body.hit_end()


func _ready():
	# Initalization here
	pass



