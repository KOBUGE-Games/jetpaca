# This file is part of the Jetpaca game
# Copyright (c) 2009-2016 Juan Linietsky, Ariel Manzur
# Distributed under the terms of the MIT license (cf. LICENSE.md file)

extends StaticBody2D

func _on_enter_screen():
	get_node("parts").set_emitting(true)

func _on_exit_screen():
	get_node("parts").set_emitting(false)
