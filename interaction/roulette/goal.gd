# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"


export var next_world=Vector2(0,0)

func _on_body_enter(  body ):
	if (body extends preload("res://player/alpaca.gd")):
		body.end_level(next_world)
	

func _ready():
	# Initalization here
	pass


