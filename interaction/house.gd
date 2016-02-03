# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends StaticBody2D

# member variables here, example:
# var a=2
# var b="textvar"

func _on_enter_screen():
	get_node("parts").set_emitting(true)

func _on_exit_screen():
	get_node("parts").set_emitting(false)

func _ready():
	# Initalization here
	pass


